"""Sanitizer support for tests of an uninstrumented interpreter, such as Python."""

# The shared runtime for each sanitizer, for the target OS; see
# //shared/bazel/toolchains/llvm.
_PRELOAD_RUNTIMES = {
    sanitizer: "//shared/bazel/toolchains/llvm:{}_runtime".format(sanitizer)
    for sanitizer in ["asan", "ubsan"]
}

def incompatible_with_unpreloadable_sanitizers():
    """Excludes an interpreter's tests from the sanitizers it can't preload.

    MSan needs every library instrumented, and TSan reports races throughout
    an uninstrumented interpreter. On macOS, SIP strips the preload on the way
    to the interpreter.
    """
    return select({
        Label("//shared/bazel/toolchains/llvm:msan"): ["@platforms//:incompatible"],
        Label("//shared/bazel/toolchains/llvm:tsan"): ["@platforms//:incompatible"],
        "//conditions:default": [],
    }) + select({
        Label("//shared/bazel/toolchains/llvm:asan_macos"): ["@platforms//:incompatible"],
        Label("//shared/bazel/toolchains/llvm:ubsan_macos"): ["@platforms//:incompatible"],
        "//conditions:default": [],
    })

def sanitizer_preload_data():
    """data for a test whose uninstrumented interpreter loads sanitized code."""
    return select({
        Label("//shared/bazel/toolchains/llvm:" + sanitizer): [Label(runtime)]
        for sanitizer, runtime in _PRELOAD_RUNTIMES.items()
    } | {"//conditions:default": []})

def sanitizer_preload_env():
    """env that has the sanitizer test wrapper preload the shared runtime.

    The interpreter isn't linked with the sanitizer's runtime, so the
    instrumented extensions it loads need it preloaded.
    """
    return select({
        Label("//shared/bazel/toolchains/llvm:" + sanitizer): {
            "WPI_SANITIZER_PRELOAD": "$(rlocationpath {})".format(Label(runtime)),
        }
        for sanitizer, runtime in _PRELOAD_RUNTIMES.items()
    } | {"//conditions:default": {}})
