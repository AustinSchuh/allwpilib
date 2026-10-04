"""target_compatible_with values for targets that can't run under sanitizers."""

def incompatible_with_sanitizers():
    """Excludes a target from every sanitizer build."""
    return select({
        Label("//shared/bazel/toolchains/llvm:sanitizer"): ["@platforms//:incompatible"],
        "//conditions:default": [],
    })

def incompatible_with_sanitizer(sanitizer):
    """Excludes a target from one sanitizer's build.

    Args:
      sanitizer: asan, msan, tsan or ubsan.

    Returns:
      A select for target_compatible_with.
    """
    return select({
        Label("//shared/bazel/toolchains/llvm:" + sanitizer): ["@platforms//:incompatible"],
        "//conditions:default": [],
    })

_RUNTIME_DIR = "@llvm_toolchain_llvm//:lib/clang/22/lib/x86_64-unknown-linux-gnu/"

_PRELOAD_RUNTIMES = {
    "asan": _RUNTIME_DIR + "libclang_rt.asan.so",
    "ubsan": _RUNTIME_DIR + "libclang_rt.ubsan_standalone.so",
}

def incompatible_with_unpreloadable_sanitizers():
    """Excludes an interpreter's tests from the sanitizers it can't preload.

    MSan needs every library instrumented, and TSan reports races throughout
    an uninstrumented interpreter.
    """
    return select({
        Label("//shared/bazel/toolchains/llvm:msan"): ["@platforms//:incompatible"],
        Label("//shared/bazel/toolchains/llvm:tsan"): ["@platforms//:incompatible"],
        "//conditions:default": [],
    })

def sanitizer_preload_data():
    """data for a test whose uninstrumented interpreter loads sanitized code."""
    return select({
        Label("//shared/bazel/toolchains/llvm:" + sanitizer): [runtime]
        for sanitizer, runtime in _PRELOAD_RUNTIMES.items()
    } | {"//conditions:default": []})

def sanitizer_preload_env():
    """env that has the sanitizer test wrapper preload the shared runtime.

    The interpreter isn't linked with the sanitizer's runtime, so the
    instrumented extensions it loads need it preloaded.
    """
    return select({
        Label("//shared/bazel/toolchains/llvm:" + sanitizer): {
            "WPI_SANITIZER_PRELOAD": "$(rlocationpath " + runtime + ")",
        }
        for sanitizer, runtime in _PRELOAD_RUNTIMES.items()
    } | {"//conditions:default": {}})
