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
