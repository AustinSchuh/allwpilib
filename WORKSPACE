load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("//thirdparty/ceres:repositories.bzl", "ceres_repositories")

ceres_repositories()

http_archive(
    name = "bazel_features",
    sha256 = "a015f3f2ebf4f1ac3f4ca8ea371610acb63e1903514fa8725272d381948d2747",
    strip_prefix = "bazel_features-1.31.0",
    url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.31.0/bazel_features-v1.31.0.tar.gz",
)

# TODO(austin): Upgrade when the patches land.
# https://github.com/bazelbuild/rules_cc/pull/430
# https://github.com/bazelbuild/rules_cc/pull/431
# https://github.com/bazelbuild/rules_cc/pull/432
http_archive(
    name = "rules_cc",
    patch_args = ["-p1"],
    patches = ["//:shared/bazel/patches/rules_cc_windows.patch"],
    sha256 = "0d3b4f984c4c2e1acfd1378e0148d35caf2ef1d9eb95b688f8e19ce0c41bdf5b",
    strip_prefix = "rules_cc-0.1.4",
    url = "https://github.com/bazelbuild/rules_cc/releases/download/0.1.4/rules_cc-0.1.4.tar.gz",
)

# TODO(austinschuh): Update to the next released apple_support once it lands.
# This needs to contain https://github.com/bazelbuild/apple_support/commit/7009b77c98a67d3fea081c9db4dbcee8effc3b7e and should be the next release after 1.22.1
http_archive(
    name = "build_bazel_apple_support",
    sha256 = "7d542be113180bc1da3660e51fe4792a867fb85537c9ef36a0d3366665a76803",
    strip_prefix = "apple_support-7009b77c98a67d3fea081c9db4dbcee8effc3b7e",
    url = "https://github.com/bazelbuild/apple_support/archive/7009b77c98a67d3fea081c9db4dbcee8effc3b7e.tar.gz",
)

http_archive(
    name = "rules_java",
    sha256 = "d31b6c69e479ffa45460b64dc9c7792a431cac721ef8d5219fc9f603fa2ff877",
    urls = [
        "https://github.com/bazelbuild/rules_java/releases/download/8.11.0/rules_java-8.11.0.tar.gz",
    ],
)

http_archive(
    name = "rules_pkg",
    sha256 = "b7215c636f22c1849f1c3142c72f4b954bb12bb8dcf3cbe229ae6e69cc6479db",
    urls = [
        "https://github.com/bazelbuild/rules_pkg/releases/download/1.1.0/rules_pkg-1.1.0.tar.gz",
    ],
)

# Rules Python
http_archive(
    name = "rules_python",
    sha256 = "0a1cefefb4a7b550fb0b43f54df67d6da95b7ba352637669e46c987f69986f6a",
    strip_prefix = "rules_python-1.5.3",
    url = "https://github.com/bazel-contrib/rules_python/releases/download/1.5.3/rules_python-1.5.3.tar.gz",
)

# Download Extra java rules
http_archive(
    name = "rules_jvm_external",
    sha256 = "4f55980c25d0783b9fe43b049362018d8d79263476b5340a5491893ffcc06ab6",
    strip_prefix = "rules_jvm_external-30899314873b6ec69dc7d02c4457fbe52a6e535d",
    url = "https://github.com/bazel-contrib/rules_jvm_external/archive/30899314873b6ec69dc7d02c4457fbe52a6e535d.tar.gz",
)

# Setup aspect lib
http_archive(
    name = "aspect_bazel_lib",
    sha256 = "a8a92645e7298bbf538aa880131c6adb4cf6239bbd27230f077a00414d58e4ce",
    strip_prefix = "bazel-lib-2.7.2",
    url = "https://github.com/aspect-build/bazel-lib/releases/download/v2.7.2/bazel-lib-v2.7.2.tar.gz",
)

# Download toolchains
http_archive(
    name = "rules_bzlmodrio_toolchains",
    sha256 = "102b4507628e9724b0c1e441727762c344e40170f65ac60516168178ea33a89a",
    url = "https://github.com/wpilibsuite/rules_bzlmodrio_toolchains/releases/download/2025-1.bcr6/rules_bzlmodrio_toolchains-2025-1.bcr6.tar.gz",
)

http_archive(
    name = "bazel_skylib",
    sha256 = "51b5105a760b353773f904d2bbc5e664d0987fbaf22265164de65d43e910d8ac",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.8.1/bazel-skylib-1.8.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.8.1/bazel-skylib-1.8.1.tar.gz",
    ],
)

http_archive(
    name = "rules_doxygen",
    sha256 = "5d154d3d011208510392b5aee8ea23ec61ab858cc1f3382b6eb8c729d3b4b336",
    strip_prefix = "rules_doxygen-2.4.2",
    url = "https://github.com/TendTo/rules_doxygen/releases/download/2.4.2/rules_doxygen-2.4.2.tar.gz",
)

http_archive(
    name = "com_google_absl",
    patch_args = ["-p1"],
    patches = [
        "@aos//third_party/abseil:0001-Add-hooks-for-using-abseil-with-AOS.patch",
        "@aos//third_party/abseil:0002-Suppress-the-stack-trace-on-SIGABRT.patch",
        "@aos//third_party/abseil:0003-Suppress-roborio-warning.patch",
    ],
    repo_mapping = {
        "@google_benchmark": "@com_github_google_benchmark",
        "@googletest": "@com_google_googletest",
    },
    sha256 = "9b7a064305e9fd94d124ffa6cc358592eb42b5da588fb4e07d09254aa40086db",
    strip_prefix = "abseil-cpp-20250512.1",
    url = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20250512.1.tar.gz",
)

http_archive(
    name = "com_google_protobuf",
    repo_mapping = {"@abseil-cpp": "@com_google_absl"},
    sha256 = "12bfd76d27b9ac3d65c00966901609e020481b9474ef75c7ff4601ac06fa0b82",
    strip_prefix = "protobuf-31.1",
    url = "https://github.com/protocolbuffers/protobuf/releases/download/v31.1/protobuf-31.1.tar.gz",
)

# Source code of LZ4 (files under lib/) are under BSD 2-Clause.
# The rest of the repository (build information, documentation, etc.) is under GPLv2.
# We only care about the lib/ subfolder anyways, and strip out any other files.
http_archive(
    name = "com_github_lz4_lz4",
    build_file = "@aos//debian:BUILD.lz4.bazel",
    sha256 = "0b0e3aa07c8c063ddf40b082bdf7e37a1562bda40a0ff5272957f3e987e0e54b",
    strip_prefix = "lz4-1.9.4/lib",
    url = "https://github.com/lz4/lz4/archive/refs/tags/v1.9.4.tar.gz",
)

http_archive(
    name = "com_github_zaphoyd_websocketpp",
    build_file = "@aos//third_party/websocketpp:websocketpp.BUILD",
    patch_args = ["-p1"],
    patches = ["@aos//third_party/websocketpp:websocketpp.patch"],
    sha256 = "6ce889d85ecdc2d8fa07408d6787e7352510750daa66b5ad44aacb47bea76755",
    strip_prefix = "websocketpp-0.8.2",
    url = "https://github.com/zaphoyd/websocketpp/archive/refs/tags/0.8.2.tar.gz",
)

http_archive(
    name = "asio",
    build_file_content = """
cc_library(
    name = "asio",
    hdrs = glob(["include/asio/**/*.hpp", "include/asio/**/*.ipp", "include/asio.hpp"]),
    visibility = ["//visibility:public"],
    defines = ["ASIO_STANDALONE"],
    includes = ["include/"],
)""",
    sha256 = "8976812c24a118600f6fcf071a20606630a69afe4c0abee3b0dea528e682c585",
    strip_prefix = "asio-1.24.0",
    url = "https://downloads.sourceforge.net/project/asio/asio/1.24.0%2520%2528Stable%2529/asio-1.24.0.tar.bz2",
)

http_archive(
    name = "com_github_foxglove_ws-protocol",
    build_file = "@aos//third_party/foxglove/ws_protocol:foxglove_ws_protocol.BUILD",
    patch_args = ["-p1"],
    patches = ["@aos//third_party/foxglove/ws_protocol:foxglove_ws_protocol.patch"],
    sha256 = "eee484aefe4cb08dcef9ec52df5f904e017e15517865dcfa2462ff8070c9d906",
    strip_prefix = "ws-protocol-releases-typescript-ws-protocol-examples-v0.8.1",
    url = "https://github.com/foxglove/ws-protocol/archive/refs/tags/releases/typescript/ws-protocol-examples/v0.8.1.tar.gz",
)

http_archive(
    name = "com_github_tartanllama_expected",
    build_file_content = """
cc_library(
  name = "com_github_tartanllama_expected",
  srcs = ["include/tl/expected.hpp"],
  includes = ["include"],
  visibility = ["//visibility:public"],
)""",
    sha256 = "1db357f46dd2b24447156aaf970c4c40a793ef12a8a9c2ad9e096d9801368df6",
    strip_prefix = "expected-1.1.0",
    url = "https://github.com/TartanLlama/expected/archive/refs/tags/v1.1.0.tar.gz",
)

http_archive(
    name = "com_github_grpc_grpc",
    patch_args = ["-p1"],
    patches = ["@aos//debian:grpc.patch"],
    sha256 = "7bf97c11cf3808d650a3a025bbf9c5f922c844a590826285067765dfd055d228",
    strip_prefix = "grpc-1.74.1",
    url = "https://github.com/grpc/grpc/archive/refs/tags/v1.74.1.tar.gz",
)

http_archive(
    name = "bazel_gazelle",
    patch_args = [
        "-p1",
    ],
    patches = [
        "@aos//third_party:bazel-gazelle/0001-Fix-visibility-of-gazelle-runner.patch",
    ],
    sha256 = "75df288c4b31c81eb50f51e2e14f4763cb7548daae126817247064637fd9ea62",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.36.0/bazel-gazelle-v0.36.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.36.0/bazel-gazelle-v0.36.0.tar.gz",
    ],
)

# This gives us a repository layout which matches what normal BCR modules expect.
# The goal here is to make it easier to depend on external projects which already
# include @eigen without introducing multiple eigen versions.
local_repository(
    name = "eigen",
    path = "wpimath/src/main/native/thirdparty/eigen/include/",
)

load("@bazel_features//:deps.bzl", "bazel_features_deps")

bazel_features_deps()

load("@build_bazel_apple_support//lib:repositories.bzl", "apple_support_dependencies")

apple_support_dependencies()

load("@rules_cc//cc:repositories.bzl", "rules_cc_toolchains")

rules_cc_toolchains()

load("@rules_java//java:rules_java_deps.bzl", "rules_java_dependencies")

rules_java_dependencies()

# note that the following line is what is minimally required from protobuf for the java rules
# consider using the protobuf_deps() public API from @com_google_protobuf//:protobuf_deps.bzl
load("@com_google_protobuf//bazel/private:proto_bazel_features.bzl", "proto_bazel_features")  # buildifier: disable=bzl-visibility

proto_bazel_features(name = "proto_bazel_features")

# register toolchains
load("@rules_java//java:repositories.bzl", "rules_java_toolchains")

rules_java_toolchains()

load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")

py_repositories()

python_register_toolchains(
    name = "python_3_10",
    ignore_root_user_error = True,
    python_version = "3.10",
)

load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "allwpilib_pip_deps",
    python_interpreter_target = "@python_3_10_host//:python",
    requirements_lock = "//:requirements_lock.txt",
)

load("@allwpilib_pip_deps//:requirements.bzl", "install_deps")

install_deps()

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@rules_jvm_external//:specs.bzl", "maven")

maven_artifacts = [
    "org.ejml:ejml-simple:0.43.1",
    "com.fasterxml.jackson.core:jackson-annotations:2.15.2",
    "com.fasterxml.jackson.core:jackson-core:2.15.2",
    "com.fasterxml.jackson.core:jackson-databind:2.15.2",
    "us.hebi.quickbuf:quickbuf-runtime:1.3.3",
    "com.google.code.gson:gson:2.10.1",
    "edu.wpi.first.thirdparty.frc2025.opencv:opencv-java:4.10.0-3",
    maven.artifact(
        "org.junit.jupiter",
        "junit-jupiter",
        "5.10.1",
        testonly = True,
    ),
    maven.artifact(
        "org.junit.platform",
        "junit-platform-console",
        "1.10.1",
        testonly = True,
    ),
    maven.artifact(
        "org.junit.platform",
        "junit-platform-launcher",
        "1.10.1",
        testonly = True,
    ),
    maven.artifact(
        "org.junit.platform",
        "junit-platform-reporting",
        "1.10.1",
        testonly = True,
    ),
    maven.artifact(
        "com.google.code.gson",
        "gson",
        "2.10.1",
        testonly = False,
    ),
    maven.artifact(
        "org.hamcrest",
        "hamcrest-all",
        "1.3",
        testonly = True,
    ),
    maven.artifact(
        "com.googlecode.junit-toolbox",
        "junit-toolbox",
        "2.4",
        testonly = True,
    ),
    maven.artifact(
        "org.apache.ant",
        "ant",
        "1.10.12",
        testonly = True,
    ),
    maven.artifact(
        "org.apache.ant",
        "ant-junit",
        "1.10.12",
        testonly = True,
    ),
    maven.artifact(
        "org.mockito",
        "mockito-core",
        "4.1.0",
        testonly = True,
    ),
    maven.artifact(
        "com.google.testing.compile",
        "compile-testing",
        "0.21.0",
        testonly = True,
    ),
]

maven_install(
    name = "maven",
    artifacts = maven_artifacts,
    maven_install_json = "//:maven_install.json",
    repositories = [
        "https://repo1.maven.org/maven2",
        "https://frcmaven.wpi.edu/artifactory/release/",
    ],
)

load("@maven//:defs.bzl", "pinned_maven_install")

pinned_maven_install()

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies", "aspect_bazel_lib_register_toolchains")

aspect_bazel_lib_dependencies()

aspect_bazel_lib_register_toolchains()

load("@rules_bzlmodrio_toolchains//:maven_deps.bzl", "setup_legacy_setup_toolchains_dependencies")

setup_legacy_setup_toolchains_dependencies()

load("@rules_bzlmodrio_toolchains//toolchains:load_toolchains.bzl", "load_toolchains")

load_toolchains()

#
http_archive(
    name = "rules_bzlmodrio_jdk",
    sha256 = "623b8bcdba1c3140f56e940365f011d2e5d90d74c7a30ace6a8817c037c1dd61",
    url = "https://github.com/wpilibsuite/rules_bzlmodRio_jdk/releases/download/17.0.12-7.bcr1/rules_bzlmodrio_jdk-17.0.12-7.bcr1.tar.gz",
)

load("@rules_bzlmodrio_jdk//:maven_deps.bzl", "setup_legacy_setup_jdk_dependencies")

setup_legacy_setup_jdk_dependencies()

register_toolchains(
    "@local_roborio//:macos",
    "@local_roborio//:linux",
    "@local_roborio//:windows",
    "@local_systemcore//:macos",
    "@local_systemcore//:linux",
    "@local_systemcore//:windows",
    "@local_raspi_bookworm_32//:macos",
    "@local_raspi_bookworm_32//:linux",
    "@local_raspi_bookworm_32//:windows",
    "@local_bookworm_32//:macos",
    "@local_bookworm_32//:linux",
    "@local_bookworm_32//:windows",
    "@local_bookworm_64//:macos",
    "@local_bookworm_64//:linux",
    "@local_bookworm_64//:windows",
    "@aos//tools/rust:rust-toolchain-x86",
    "@aos//tools/rust:rust-toolchain-armv7",
    "@aos//tools/rust:rust-toolchain-arm64",
)

setup_legacy_setup_jdk_dependencies()

http_archive(
    name = "bzlmodrio-ni",
    sha256 = "fff62c3cb3e83f9a0d0a01f1739477c9ca5e9a6fac05be1ad59dafcd385801f7",
    url = "https://github.com/wpilibsuite/bzlmodRio-ni/releases/download/2025.2.0/bzlmodRio-ni-2025.2.0.tar.gz",
)

load("@bzlmodrio-ni//:maven_cpp_deps.bzl", "setup_legacy_bzlmodrio_ni_cpp_dependencies")

setup_legacy_bzlmodrio_ni_cpp_dependencies()

http_archive(
    name = "bzlmodrio-opencv",
    sha256 = "867ec3e90b7efc30ff6eb68d14050e7f1e800656d390505b135069f080c5cd91",
    url = "https://github.com/wpilibsuite/bzlmodRio-opencv/releases/download/2025.4.10.0-3.bcr5/bzlmodRio-opencv-2025.4.10.0-3.bcr5.tar.gz",
)

load("@bzlmodrio-opencv//:maven_cpp_deps.bzl", "setup_legacy_bzlmodrio_opencv_cpp_dependencies")

setup_legacy_bzlmodrio_opencv_cpp_dependencies()

http_archive(
    name = "bzlmodrio-libssh",
    sha256 = "f8fef627c7b393f7f6ed638e12b80ff90b2cfea11488b15214f25ce1e470723a",
    url = "https://github.com/wpilibsuite/bzlmodRio-libssh/releases/download/2024.0.105-1.bcr1/bzlmodrio-libssh-2024.0.105-1.bcr1.tar.gz",
)

load("@bzlmodrio-libssh//:maven_cpp_deps.bzl", "setup_legacy_bzlmodrio_libssh_cpp_dependencies")

setup_legacy_bzlmodrio_libssh_cpp_dependencies()

# Setup quickbuf compiler
QUICKBUF_VERSION = "1.3.2"

http_file(
    name = "quickbuffer_protoc_linux",
    executable = True,
    sha256 = "f9a041bccaa7040db523666ef1b5fe9f6f94e70a82c88951f18f58aadd9c50b5",
    url = "https://repo1.maven.org/maven2/us/hebi/quickbuf/protoc-gen-quickbuf/" + QUICKBUF_VERSION + "/protoc-gen-quickbuf-" + QUICKBUF_VERSION + "-linux-x86_64.exe",
)

http_file(
    name = "quickbuffer_protoc_osx_x86-64",
    executable = True,
    sha256 = "ea307c2b69664ae7e7c69db4cddf5803187e5a34bceffd09a21652f0f16044f7",
    url = "https://repo1.maven.org/maven2/us/hebi/quickbuf/protoc-gen-quickbuf/" + QUICKBUF_VERSION + "/protoc-gen-quickbuf-" + QUICKBUF_VERSION + "-osx-x86_64.exe   ",
)

http_file(
    name = "quickbuffer_protoc_osx_aarch64",
    executable = True,
    sha256 = "a9abdee09d8b5ef0aa954b238536917313511deec11e1901994af26ade033e28",
    url = "https://repo1.maven.org/maven2/us/hebi/quickbuf/protoc-gen-quickbuf/" + QUICKBUF_VERSION + "/protoc-gen-quickbuf-" + QUICKBUF_VERSION + "-osx-aarch_64.exe   ",
)

http_file(
    name = "quickbuffer_protoc_windows",
    executable = True,
    sha256 = "27dc1f29764a62b5e6a813a4bcd63e81bbdc3394da760a44acae1025b4a89f1d",
    url = "https://repo1.maven.org/maven2/us/hebi/quickbuf/protoc-gen-quickbuf/" + QUICKBUF_VERSION + "/protoc-gen-quickbuf-" + QUICKBUF_VERSION + "-windows-x86_64.exe ",
)

# Setup rules_proto
http_archive(
    name = "rules_proto",
    sha256 = "0e5c64a2599a6e26c6a03d6162242d231ecc0de219534c38cb4402171def21e8",
    strip_prefix = "rules_proto-7.0.2",
    url = "https://github.com/bazelbuild/rules_proto/releases/download/7.0.2/rules_proto-7.0.2.tar.gz",
)

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies")

rules_proto_dependencies()

load("@rules_proto//proto:setup.bzl", "rules_proto_setup")

rules_proto_setup()

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

# Capture the repository environmental variables which specify the filter list for what architectures to build in CI.
load("//shared/bazel/rules:publishing_rule.bzl", "publishing_repo")

publishing_repo(
    name = "com_wpilib_allwpilib_publishing_config",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@rules_doxygen//:extensions.bzl", "doxygen_repository")

# Download the os specific version 1.12.0 of doxygen supporting all the indicated platforms
doxygen_repository(
    name = "doxygen",
    executables = [
        "",
        "",
        "",
    ],
    platforms = [
        "windows",
        "mac",
        "linux",
    ],
    sha256s = [
        "07f1c92cbbb32816689c725539c0951f92c6371d3d7f66dfa3192cbe88dd3138",
        "6ace7dde967d41f4e293d034a67eb2c7edd61318491ee3131112173a77344001",
        "3c42c3f3fb206732b503862d9c9c11978920a8214f223a3950bbf2520be5f647",
    ],
    versions = [
        "1.12.0",
        "1.12.0",
        "1.12.0",
    ],
)

http_archive(
    name = "aos",
    patch_args = ["-p1"],
    patches = [
        "//:aos.patch",
    ],
    repo_mapping = {
        "@pip_deps": "@allwpilib_pip_deps",
    },
    sha256 = "d410d90d922094c637f3b5a42363c1d8a5fe5f6263e41e68144d88ea478e1e84",
    strip_prefix = "aos-55869cb48cf27a0273fdae4ef278049f83326949",
    url = "https://github.com/AustinSchuh/aos/archive/55869cb48cf27a0273fdae4ef278049f83326949.tar.gz",
)

#local_repository(
#name = "aos",
#path = "/home/austin/local/aos/",
#repo_mapping = {
#"@pip_deps": "@allwpilib_pip_deps",
#},
#)

#local_repository(
#name = "com_github_google_flatbuffers",
#path = "/home/austin/local/aos/third_party/flatbuffers/",
#)

http_archive(
    name = "com_github_google_flatbuffers",
    repo_mapping = {
        "@pip_deps": "@allwpilib_pip_deps",
    },
    sha256 = "d410d90d922094c637f3b5a42363c1d8a5fe5f6263e41e68144d88ea478e1e84",
    strip_prefix = "aos-55869cb48cf27a0273fdae4ef278049f83326949/third_party/flatbuffers",
    url = "https://github.com/AustinSchuh/aos/archive/55869cb48cf27a0273fdae4ef278049f83326949.tar.gz",
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "af47f30e9cbd70ae34e49866e201b3f77069abb111183f2c0297e7e74ba6bbc0",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.47.0/rules_go-v0.47.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.47.0/rules_go-v0.47.0.zip",
    ],
)

http_archive(
    name = "rules_rust",
    integrity = "sha256-w4tiLybzXDRzgQDibReT/yUolzgVRkZ7IticnU2L/VA=",
    urls = ["https://github.com/bazelbuild/rules_rust/releases/download/0.63.0/rules_rust-0.63.0.tar.gz"],
)

load("@rules_rust//rust:repositories.bzl", "rust_analyzer_toolchain_repository", "rust_repository_set")

RUST_VERSION = "1.81.0"

rust_repository_set(
    name = "rust",
    allocator_library = "@aos//tools/rust:forward_allocator",
    edition = "2021",
    exec_triple = "x86_64-unknown-linux-gnu",
    extra_target_triples = [
        "arm-unknown-linux-gnueabi",
        "armv7-unknown-linux-gnueabihf",
        "aarch64-unknown-linux-gnu",
    ],
    register_toolchain = False,
    rustfmt_version = RUST_VERSION,
    versions = [RUST_VERSION],
)

load("@rules_rust//crate_universe:repositories.bzl", "crate_universe_dependencies")

crate_universe_dependencies()

load("@rules_rust//crate_universe:defs.bzl", "crate", "crates_repository")

# Run `CARGO_BAZEL_REPIN=1 bazel sync --only=crate_index` to update the lock file
# after adding or removing any dependencies.
crates_repository(
    name = "crate_index",
    annotations = {
        "cxx": [
            crate.annotation(
                additive_build_file = "@aos//third_party/cargo:cxx/include.BUILD.bazel",
                extra_aliased_targets = {"cxx_cc": "cxx_cc"},
                gen_build_script = False,
            ),
        ],
        "link-cplusplus": [
            # Bazel toolchains take care of linking the C++ standard library, so don't add
            # an extra flag via Rust by enabling the `nothing` feature. I'm not even sure
            # it would end up on the link command line, but this crate's build.rs attempts
            # to find a C++ compiler itself otherwise which definitely doesn't work.
            crate.annotation(
                crate_features = ["nothing"],
            ),
        ],
        "log": [
            crate.annotation(
                rustc_flags = ["--cfg=atomic_cas"],
            ),
        ],
    },
    cargo_lockfile = "//:Cargo.lock",
    lockfile = "//:Cargo.Bazel.lock",
    manifests = [
        "@aos//:Cargo.toml",
        "@aos//third_party/autocxx:Cargo.toml",
        "@aos//third_party/autocxx:engine/Cargo.toml",
        "@aos//third_party/autocxx:parser/Cargo.toml",
        "@aos//third_party/autocxx:gen/cmd/Cargo.toml",
        "@aos//third_party/autocxx:macro/Cargo.toml",
        "@aos//third_party/autocxx:integration-tests/Cargo.toml",
    ],
    rust_toolchain_cargo_template = "@rust__{triple}__{channel}_tools//:bin/{tool}",
    rust_toolchain_rustc_template = "@rust__{triple}__{channel}_tools//:bin/{tool}",
    rust_version = RUST_VERSION,
    supported_platform_triples = [
        "x86_64-unknown-linux-gnu",
        "arm-unknown-linux-gnueabi",
        "armv7-unknown-linux-gnueabihf",
        "aarch64-unknown-linux-gnu",
    ],
)

load("@crate_index//:defs.bzl", "crate_repositories")

crate_repositories()

load("@rules_rust//tools/rust_analyzer:deps.bzl", "rust_analyzer_dependencies")

rust_analyzer_dependencies()

register_toolchains(rust_analyzer_toolchain_repository(
    name = "rust_analyzer_toolchain",
    version = RUST_VERSION,
))

http_archive(
    name = "cxxbridge-cmd",
    build_file = "@aos//third_party/cargo:cxxbridge-cmd/include.BUILD.bazel",
    sha256 = "df13eece12ed9e7bd4fb071a6af4c44421bb9024d339d029f5333bcdaca00000",
    strip_prefix = "cxxbridge-cmd-1.0.100",
    type = "tar.gz",
    urls = ["https://crates.io/api/v1/crates/cxxbridge-cmd/1.0.100/download"],
)

crates_repository(
    name = "cxxbridge_cmd_deps",
    cargo_lockfile = "//third_party/cargo:cxxbridge-cmd/Cargo.lock",
    lockfile = "//third_party/cargo:cxxbridge-cmd/Cargo.Bazel.lock",
    manifests = ["@cxxbridge-cmd//:Cargo.toml"],
    rust_toolchain_cargo_template = "@rust__{triple}__{channel}_tools//:bin/{tool}",
    rust_toolchain_rustc_template = "@rust__{triple}__{channel}_tools//:bin/{tool}",
    rust_version = "1.81.0",
    supported_platform_triples = [
        "x86_64-unknown-linux-gnu",
        "arm-unknown-linux-gnueabi",
        "armv7-unknown-linux-gnueabihf",
        "aarch64-unknown-linux-gnu",
    ],
)

load("@cxxbridge_cmd_deps//:defs.bzl", cxxbridge_cmd_deps = "crate_repositories")

cxxbridge_cmd_deps()

load("@io_bazel_rules_go//go:deps.bzl", "go_download_sdk", "go_register_toolchains", "go_rules_dependencies")

go_download_sdk(
    name = "go_sdk",
    goarch = "amd64",
    goos = "linux",
    sdks = {
        # Pulled from https://go.dev/dl/ to avoid the external dependency.
        "linux_amd64": ("go1.19.5.linux-amd64.tar.gz", "36519702ae2fd573c9869461990ae550c8c0d955cd28d2827a6b159fda81ff95"),
    },
    version = "1.19.5",
)

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")

grpc_deps()

load("@com_github_grpc_grpc//bazel:grpc_extra_deps.bzl", "grpc_extra_deps")

grpc_extra_deps()

http_archive(
    name = "rules_rust_tinyjson",
    build_file = "@rules_rust//util/process_wrapper:BUILD.tinyjson.bazel",
    sha256 = "1a8304da9f9370f6a6f9020b7903b044aa9ce3470f300a1fba5bc77c78145a16",
    strip_prefix = "tinyjson-2.3.0",
    type = "tar.gz",
    url = "https://crates.io/api/v1/crates/tinyjson/2.3.0/download",
)

http_archive(
    name = "aspect_rules_js",
    sha256 = "b71565da7a811964e30cccb405544d551561e4b56c65f0c0aeabe85638920bd6",
    strip_prefix = "rules_js-2.4.2",
    url = "https://github.com/aspect-build/rules_js/releases/download/v2.4.2/rules_js-v2.4.2.tar.gz",
)

http_archive(
    name = "aspect_rules_rollup",
    sha256 = "0b8ac7d97cd660eb9a275600227e9c4268f5904cba962939d1a6ce9a0a059d2e",
    strip_prefix = "rules_rollup-2.0.1",
    url = "https://github.com/aspect-build/rules_rollup/releases/download/v2.0.1/rules_rollup-v2.0.1.tar.gz",
)

load("@aspect_rules_rollup//rollup:dependencies.bzl", "rules_rollup_dependencies")

rules_rollup_dependencies()

load("@aspect_rules_js//js:repositories.bzl", "rules_js_dependencies")

rules_js_dependencies()

http_archive(
    name = "aspect_rules_esbuild",
    sha256 = "530adfeae30bbbd097e8af845a44a04b641b680c5703b3bf885cbd384ffec779",
    strip_prefix = "rules_esbuild-0.22.1",
    url = "https://github.com/aspect-build/rules_esbuild/releases/download/v0.22.1/rules_esbuild-v0.22.1.tar.gz",
)

http_archive(
    name = "aspect_rules_terser",
    sha256 = "c2013d66903fa42047b3bebeb4fc4a16ba380c310f772d8b28aaf8b5af6a1032",
    strip_prefix = "rules_terser-2.0.1",
    url = "https://github.com/aspect-build/rules_terser/releases/download/v2.0.1/rules_terser-v2.0.1.tar.gz",
)

load("@aspect_rules_esbuild//esbuild:dependencies.bzl", "rules_esbuild_dependencies")

rules_esbuild_dependencies()

load("@aspect_rules_js//js:toolchains.bzl", "DEFAULT_NODE_VERSION", "rules_js_register_toolchains")

rules_js_register_toolchains(node_version = DEFAULT_NODE_VERSION)

load("@aspect_rules_terser//terser:dependencies.bzl", "rules_terser_dependencies")

rules_terser_dependencies()

http_archive(
    name = "aspect_rules_ts",
    sha256 = "09af62a0d46918d815b5f48b5ed0f5349b62c15fc42fcc3fef5c246504ff8d99",
    strip_prefix = "rules_ts-3.6.3",
    url = "https://github.com/aspect-build/rules_ts/releases/download/v3.6.3/rules_ts-v3.6.3.tar.gz",
)

load("@aspect_rules_ts//ts:repositories.bzl", "rules_ts_dependencies")

rules_ts_dependencies(
    ts_version_from = "@aos//:package.json",
)

load("@aspect_rules_js//npm:repositories.bzl", "npm_translate_lock")

npm_translate_lock(
    name = "npm",
    data = [
        "@aos//:package.json",
        "@aos//:pnpm-workspace.yaml",
        "@aos//aos/analysis/foxglove_extension:package.json",
        "@aos//control_loops/swerve/spline_ui/www:package.json",
    ],

    # Running lifecycle hooks on npm package fsevents@2.3.2 fails in a dramatic way:
    # ```
    # SyntaxError: Unexpected strict mode reserved word
    # at ESMLoader.moduleStrategy (node:internal/modules/esm/translators:117:18)
    # at ESMLoader.moduleProvider (node:internal/modules/esm/loader:337:14)
    # at async link (node:internal/modules/esm/module_job:70:21)
    # ```
    lifecycle_hooks_no_sandbox = False,
    npmrc = "@aos//:.npmrc",
    pnpm_lock = "//:pnpm-lock.yaml",
    quiet = False,
    update_pnpm_lock = False,
    verify_node_modules_ignored = "//:.bazelignore",
)

load("@aspect_rules_esbuild//esbuild:repositories.bzl", "LATEST_ESBUILD_VERSION", "esbuild_register_toolchains")

esbuild_register_toolchains(
    name = "esbuild",
    esbuild_version = LATEST_ESBUILD_VERSION,
)

load("@npm//:repositories.bzl", "npm_repositories")

npm_repositories()

http_archive(
    name = "aspect_rules_cypress",
    patch_args = ["-p1"],
    patches = [
        "@aos//third_party:rules_cypress/0001-fix-incorrect-linux-checksums.patch",
        "@aos//third_party:rules_cypress/0002-Add-support-for-cypress-13.6.6.patch",
    ],
    sha256 = "76947778d8e855eee3c15931e1fcdc1c2a25d56d6c0edd110b2227c05b794d08",
    strip_prefix = "rules_cypress-0.3.2",
    urls = [
        "https://github.com/aspect-build/rules_cypress/archive/refs/tags/v0.3.2.tar.gz",
    ],
)

load("@aspect_rules_cypress//cypress:dependencies.bzl", "rules_cypress_dependencies")
load("@aspect_rules_cypress//cypress:repositories.bzl", "cypress_register_toolchains")

rules_cypress_dependencies()

cypress_register_toolchains(
    name = "cypress",
    cypress_version = "13.3.1",
)

load("@com_github_google_flatbuffers//ts:repositories.bzl", "flatbuffers_npm")

flatbuffers_npm(
    name = "flatbuffers_npm",
)

load("@flatbuffers_npm//:repositories.bzl", fbs_npm_repositories = "npm_repositories")

fbs_npm_repositories()

# Shamelessly stolen from https://github.com/bazelbuild/bazel-central-registry/blob/main/modules/xz/5.4.5.bcr.5
http_archive(
    name = "xz",
    integrity = "sha256-E1yQuTSu6PvA1Gfeh6Bctw1ifaNqvlGMNXqHNwnlt9Y=",
    patch_args = ["-p1"],
    patches = ["//:thirdparty/xz/bzlmod.patch"],
    strip_prefix = "xz-5.4.5",
    url = "https://github.com/tukaani-project/xz/releases/download/v5.4.5/xz-5.4.5.tar.gz",
)

load("@aos//:repositories.bzl", aos_repositories = "repositories")

aos_repositories()
