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
        "linuxarm32static": ("linux", "**/*.a", "sha256-/T5gxzmNcLsHDYw1Z7jDyF2tyX41ZpFklhE/RkAGCdg="),
        "linuxarm32staticdebug": ("linux", "**/*.a", "sha256-BqVmOxX2h4SHs8VDkaITodUQYioCcCrLQSn02WqeYcU="),
        "linuxarm64static": ("linux", "**/*.a", "sha256-t4O0uNldvTVHOHzFFL2kFPtkRjhhB/mCLUaGqCZGRfU="),
        "linuxarm64staticdebug": ("linux", "**/*.a", "sha256-Kx7KKmgAbWlc/soFUjvkL71tJ0lXcQZNnuCRDXx5EvE="),
        "linuxx86-64static": ("linux", "**/*.a", "sha256-hnu8IPvOHeob+bziww9DoNpxj6Y8I4xigzN5u9a10Q8="),
        "linuxx86-64staticdebug": ("linux", "**/*.a", "sha256-YHAdIMwum7fwHVouDLFSY2eB9qJ6+TlToKgkDjl+eWQ="),
        "osxuniversalstatic": ("osx", "**/*.a", "sha256-RFs2zECinIXjV7ADwZgZuUpd3ejnaF8h+aLxPizmO4o="),
        "osxuniversalstaticdebug": ("osx", "**/*.a", "sha256-WcUduHbmgD/1UgWFHi59ZOWiHfHy4tmpmwBbDUxbUq0="),
        "windowsarm64static": ("windows", "**/*.lib", "sha256-u2M+QCOsT4KyES7wj55z6Myb09Q4jx376z4qmWkKHEM="),
        "windowsarm64staticdebug": ("windows", "**/*.lib", "sha256-iwXfrj5p1VRLpAyy0fj5ntrKGgsgqJq6KIMH4YxB9xg="),
        "windowsx86-64static": ("windows", "**/*.lib", "sha256-rFIRm4+Z0osAL+6ljIRZDFzEKLYzXqf/4T31wfFTj3c="),
        "windowsx86-64staticdebug": ("windows", "**/*.lib", "sha256-DoD07iN+SE7Qlw3T7/2WBvK7ASL0N4OxW2OQFW9uvRE="),
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

        url_fname = "ceres-cpp-2.2-2-" + artifact + ".zip"

        http_archive(
            name = repo_name,
            build_file_content = build_file_content,
            strip_prefix = prefix,
            url = "https://frcmaven.wpi.edu/artifactory/development/edu/wpi/first/thirdparty/frc2025/ceres/ceres-cpp/2.2-2/" + url_fname,
            integrity = integrity,
        )
