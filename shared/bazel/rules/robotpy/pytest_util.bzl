load("@rules_python_pytest//python_pytest:defs.bzl", "py_pytest_test")
load("//shared/bazel/rules:sanitizers.bzl", "incompatible_with_unpreloadable_sanitizers", "sanitizer_preload_data", "sanitizer_preload_env")
load("//shared/bazel/rules/robotpy:compatibility_select.bzl", "robotpy_compatibility_select")

def robotpy_py_test(name, srcs, tags = [], size = "small", data = [], **kwargs):
    py_pytest_test(
        name = name,
        size = size,
        srcs = srcs,
        # The interpreter isn't instrumented, so it preloads the sanitizer
        # runtime for the extensions it loads.
        data = data + sanitizer_preload_data(),
        env = sanitizer_preload_env(),
        target_compatible_with = robotpy_compatibility_select() + incompatible_with_unpreloadable_sanitizers(),
        tags = tags + [
            "robotpy",
        ],
        legacy_create_init = 0,
        **kwargs
    )
