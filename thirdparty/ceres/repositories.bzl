""" Starlark file for ceres repository definitions """

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")



def ceres_repositories():
    """ Fetches the ceres solver libraries """

    http_archive(
        name = "ceres_headers",
        build_file_content = """
load(\"@rules_cc//cc:defs.bzl\", \"cc_library\")

cc_library(
    name = \"headers\",
    #hdrs = glob(["**"], exclude = ["LICENSE.md", "signature_of_eigen3_matrix_library"]),
    hdrs = glob(["ceres/**", "glog/**", "suitesparse/**", "openblas/**"]),
    includes = ["."],
    deps = ["@//wpimath:eigen-headers"],
    visibility = [\"//visibility:public\"],
)
""",
        url = "https://frcmaven.wpi.edu/artifactory/development/edu/wpi/first/thirdparty/frc2025/ceres/ceres-cpp/2.2-2/ceres-cpp-2.2-2-headers.zip",
        integrity = "sha256-h5GHasG2vpbMWqXuC+0vBoXSW2G3av5Msv3+sCk01gk=",
    )

    _LIB_ARTIFACTS = {
        "linuxarm32static": ("linux", "**/*.a", None),
        "linuxarm32staticdebug": ("linux", "**/*.a", None),
        "linuxarm64static": ("linux", "**/*.a", None),
        "linuxarm64staticdebug": ("linux", "**/*.a", None),
        "linuxx86-64static": ("linux", "**/*.a", "sha256-hnu8IPvOHeob+bziww9DoNpxj6Y8I4xigzN5u9a10Q8="),
        "linuxx86-64staticdebug": ("linux", "**/*.a", None),
        "osxuniversalstatic": ("osx", "**/*.a", None),
        "osxuniversalstaticdebug": ("osx", "**/*.a", None),
        "windowsarm64static": ("windows", "**/*.lib", None),
        "windowsarm64staticdebug": ("windows", "**/*.lib", None),
        "windowsx86-64static": ("windows", "**/*.lib", None),
        "windowsx86-64staticdebug": ("windows", "**/*.lib", None),
    }

    for artifact, (prefix, glob_pattern, integrity) in _LIB_ARTIFACTS.items():
        repo_name = "ceres_" + artifact
        build_file_content = """
filegroup(
    name = \"lib\",
    srcs = glob([\"%s\"]),
    visibility = [\"//visibility:public\"],
)
""" % glob_pattern

        if "debug" in artifact:
            url_fname = "ceres-cpp-2.2-2-" + artifact.replace("staticdebug", "") + "static-debug.zip"
        else:
            url_fname = "ceres-cpp-2.2-2-" + artifact.replace("static", "") + "static.zip"

        http_archive(
            name = repo_name,
            build_file_content = build_file_content,
            strip_prefix = prefix,
            url = "https://frcmaven.wpi.edu/artifactory/development/edu/wpi/first/thirdparty/frc2025/ceres/ceres-cpp/2.2-2/" + url_fname,
            integrity = integrity,
        )
