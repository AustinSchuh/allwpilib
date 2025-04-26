load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_cc",
    sha256 = "712d77868b3152dd618c4d64faaddefcc5965f90f5de6e6dd1d5ddcd0be82d42",
    strip_prefix = "rules_cc-0.1.1",
    urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.1.1/rules_cc-0.1.1.tar.gz"],
)

http_archive(
    name = "com_google_protobuf",
    sha256 = "07a43d88fe5a38e434c7f94129cad56a4c43a51f99336074d0799c2f7d4e44c5",
    strip_prefix = "protobuf-30.2",
    url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v30.2.tar.gz",
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("@rules_java//java:rules_java_deps.bzl", "rules_java_dependencies")

rules_java_dependencies()

load("@rules_java//java:repositories.bzl", "rules_java_toolchains")

rules_java_toolchains()

load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()

# Download Extra java rules
http_archive(
    name = "rules_jvm_external",
    sha256 = "08ea921df02ffe9924123b0686dc04fd0ff875710bfadb7ad42badb931b0fd50",
    strip_prefix = "rules_jvm_external-6.1",
    url = "https://github.com/bazelbuild/rules_jvm_external/releases/download/6.1/rules_jvm_external-6.1.tar.gz",
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@rules_jvm_external//:specs.bzl", "maven")

maven_artifacts = [
    "org.ejml:ejml-simple:0.43.1",
    "com.fasterxml.jackson.core:jackson-annotations:2.15.2",
    "com.fasterxml.jackson.core:jackson-core:2.15.2",
    "com.fasterxml.jackson.core:jackson-databind:2.15.2",
    "us.hebi.quickbuf:quickbuf-runtime:1.3.3",
    "com.google.code.gson:gson:2.10.1",
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
    repositories = [
        "https://repo1.maven.org/maven2",
        "https://frcmaven.wpi.edu/artifactory/release/",
    ],
)

# Download toolchains
http_archive(
    name = "rules_bzlmodrio_toolchains",
    sha256 = "9265c3cdada00f339a73eab0cc966aa21d8cf804331d0f833251936eb6b1bf0e",
    strip_prefix = "rules_bzlmodrio_toolchains-2e661a530b7492bd6d15bd7a8bc40a08870c4206",
    url = "https://github.com/wpilibsuite/rules_bzlmodrio_toolchains/archive/2e661a530b7492bd6d15bd7a8bc40a08870c4206.tar.gz",
)

load("@rules_bzlmodrio_toolchains//:maven_deps.bzl", "setup_legacy_setup_toolchains_dependencies")

setup_legacy_setup_toolchains_dependencies()

load("@rules_bzlmodrio_toolchains//toolchains:load_toolchains.bzl", "load_toolchains")

load_toolchains()

#
http_archive(
    name = "rules_bzlmodrio_jdk",
    sha256 = "81869fe9860e39b17e4a9bc1d33c1ca2faede7e31d9538ed0712406f753a2163",
    url = "https://github.com/wpilibsuite/rules_bzlmodRio_jdk/releases/download/17.0.12-7/rules_bzlmodRio_jdk-17.0.12-7.tar.gz",
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
    "@local_raspi_bullseye_32//:macos",
    "@local_raspi_bullseye_32//:linux",
    "@local_raspi_bullseye_32//:windows",
    "@local_raspi_bookworm_32//:macos",
    "@local_raspi_bookworm_32//:linux",
    "@local_raspi_bookworm_32//:windows",
    "@local_bullseye_32//:macos",
    "@local_bullseye_32//:linux",
    "@local_bullseye_32//:windows",
    "@local_bullseye_64//:macos",
    "@local_bullseye_64//:linux",
    "@local_bullseye_64//:windows",
    "@local_bookworm_32//:macos",
    "@local_bookworm_32//:linux",
    "@local_bookworm_32//:windows",
    "@local_bookworm_64//:macos",
    "@local_bookworm_64//:linux",
    "@local_bookworm_64//:windows",
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
    sha256 = "ba3f4910ce9cc0e08abff732aeb5835b1bcfd864ca5296edeadcf2935f7e81b9",
    url = "https://github.com/wpilibsuite/bzlmodRio-opencv/releases/download/2025.4.10.0-3.bcr1/bzlmodRio-opencv-2025.4.10.0-3.bcr1.tar.gz",
)

load("@bzlmodrio-opencv//:maven_cpp_deps.bzl", "setup_legacy_bzlmodrio_opencv_cpp_dependencies")

setup_legacy_bzlmodrio_opencv_cpp_dependencies()

load("@bzlmodrio-opencv//:maven_java_deps.bzl", "setup_legacy_bzlmodrio_opencv_java_dependencies")

setup_legacy_bzlmodrio_opencv_java_dependencies()

http_archive(
    name = "build_bazel_apple_support",
    sha256 = "c4bb2b7367c484382300aee75be598b92f847896fb31bbd22f3a2346adf66a80",
    url = "https://github.com/bazelbuild/apple_support/releases/download/1.15.1/apple_support.1.15.1.tar.gz",
)

load(
    "@build_bazel_apple_support//lib:repositories.bzl",
    "apple_support_dependencies",
)

apple_support_dependencies()

#local_repository(
#    name = "aos",
#    path = "/home/austin/local/aos/",
#)

http_archive(
    name = "aos",
    sha256 = "8c6b82741f6c8fb0cc3bfe6de0604a02bb1ff0457ecdf24919dd9110916de788",
    strip_prefix = "aos-daeff11b096936f34006393128bf47898ea38fa3",
    url = "https://github.com/RealtimeRoboticsGroup/aos/archive/daeff11b096936f34006393128bf47898ea38fa3.zip",
)

http_archive(
    name = "com_github_google_flatbuffers",
    sha256 = "8c6b82741f6c8fb0cc3bfe6de0604a02bb1ff0457ecdf24919dd9110916de788",
    strip_prefix = "aos-daeff11b096936f34006393128bf47898ea38fa3/third_party/flatbuffers/",
    url = "https://github.com/RealtimeRoboticsGroup/aos/archive/daeff11b096936f34006393128bf47898ea38fa3.zip",
)

#local_repository(
#name = "com_github_google_flatbuffers",
#path = "/home/austin/local/aos/third_party/flatbuffers/",
#)

http_archive(
    name = "aspect_bazel_lib",
    sha256 = "40ba9d0f62deac87195723f0f891a9803a7b720d7b89206981ca5570ef9df15b",
    strip_prefix = "bazel-lib-2.14.0",
    url = "https://github.com/bazel-contrib/bazel-lib/releases/download/v2.14.0/bazel-lib-v2.14.0.tar.gz",
)

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies", "aspect_bazel_lib_register_toolchains", "register_jq_toolchains")

aspect_bazel_lib_dependencies()

aspect_bazel_lib_register_toolchains()

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "f2d15bea3e241aa0e3a90fb17a82e6a8ab12214789f6aeddd53b8d04316d2b7c",
    urls = [
        "https://mirror.bazel.build/github.com/bazel-contrib/rules_go/releases/download/v0.54.0/rules_go-v0.54.0.zip",
        "https://github.com/bazel-contrib/rules_go/releases/download/v0.54.0/rules_go-v0.54.0.zip",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.24.2")

#local_repository(
#name = "rules_rust",
#path = "/home/austin/local/aos/third_party/rules_rust",
#)
http_archive(
    name = "rules_rust",
    sha256 = "8c6b82741f6c8fb0cc3bfe6de0604a02bb1ff0457ecdf24919dd9110916de788",
    strip_prefix = "aos-daeff11b096936f34006393128bf47898ea38fa3/third_party/rules_rust/",
    url = "https://github.com/RealtimeRoboticsGroup/aos/archive/daeff11b096936f34006393128bf47898ea38fa3.zip",
)

load("@rules_rust//rust:repositories.bzl", "rust_analyzer_toolchain_repository", "rust_repository_set")

RUST_VERSION = "1.70.0"

rust_repository_set(
    name = "rust",
    allocator_library = "@//tools/rust:forward_allocator",
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
        "link-cplusplus": [
            # Bazel toolchains take care of linking the C++ standard library, so don't add
            # an extra flag via Rust by enabling the `nothing` feature. I'm not even sure
            # it would end up on the link command line, but this crate's build.rs attempts
            # to find a C++ compiler itself otherwise which definitely doesn't work.
            crate.annotation(
                crate_features = ["nothing"],
            ),
        ],
        "cxx": [
            crate.annotation(
                additive_build_file = "@aos//third_party/cargo:cxx/include.BUILD.bazel",
                extra_aliased_targets = ["cxx_cc"],
                gen_build_script = False,
            ),
        ],
        "log": [
            crate.annotation(
                rustc_flags = ["--cfg=atomic_cas"],
            ),
        ],
    },
    cargo_lockfile = "//:Cargo.lock",
    generator_sha256s = {"x86_64-unknown-linux-gnu": "1987a00e7ae12c705fa010b340410230ae8a47d7d95c02900191968b2e745649"},
    generator_urls = {
        "x86_64-unknown-linux-gnu": "https://realtimeroboticsgroup.org/build-dependencies/cargo-bazel-x86_64-unknown-linux-gnu",
    },
    lockfile = "//:Cargo.Bazel.lock",
    manifests = [
        "@aos//:Cargo.toml",
        "@aos//third_party/autocxx:Cargo.toml",
        "@aos//third_party/autocxx:engine/Cargo.toml",
        "@aos//third_party/autocxx:parser/Cargo.toml",
        "@aos//third_party/autocxx:gen/cmd/Cargo.toml",
        "@aos//third_party/autocxx:macro/Cargo.toml",
        "@aos//third_party/autocxx:integration-tests/Cargo.toml",
        "@com_github_google_flatbuffers//rust:flatbuffers/Cargo.toml",
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
    generator_sha256s = {"x86_64-unknown-linux-gnu": "1987a00e7ae12c705fa010b340410230ae8a47d7d95c02900191968b2e745649"},
    generator_urls = {
        "x86_64-unknown-linux-gnu": "https://realtimeroboticsgroup.org/build-dependencies/cargo-bazel-x86_64-unknown-linux-gnu",
    },
    lockfile = "//third_party/cargo:cxxbridge-cmd/Cargo.Bazel.lock",
    manifests = ["@cxxbridge-cmd//:Cargo.toml"],
    rust_toolchain_cargo_template = "@rust__{triple}__{channel}_tools//:bin/{tool}",
    rust_toolchain_rustc_template = "@rust__{triple}__{channel}_tools//:bin/{tool}",
    rust_version = "1.70.0",
    supported_platform_triples = [
        "x86_64-unknown-linux-gnu",
        "arm-unknown-linux-gnueabi",
        "armv7-unknown-linux-gnueabihf",
        "aarch64-unknown-linux-gnu",
    ],
)

load("@cxxbridge_cmd_deps//:defs.bzl", cxxbridge_cmd_deps = "crate_repositories")

cxxbridge_cmd_deps()

http_archive(
    name = "aspect_rules_ts",
    sha256 = "6ad28b5bac2bb5a74e737925fbc3f62ce1edabe5a48d61a9980c491ef4cedfb7",
    strip_prefix = "rules_ts-2.1.1",
    url = "https://github.com/aspect-build/rules_ts/releases/download/v2.1.1/rules_ts-v2.1.1.tar.gz",
)

load("@aspect_rules_ts//ts:repositories.bzl", "rules_ts_dependencies")

rules_ts_dependencies(
    ts_version_from = "@aos//:package.json",
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

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

http_archive(
    name = "aspect_rules_js",
    patch_args = [
        "-p1",
    ],
    patches = [
        "//third_party:rules_js/0001-Fix-package-permissions.patch",
    ],
    sha256 = "bc9b4a01ef8eb050d8a7a050eedde8ffb1e45a56b0e4094e26f06c17d5fcf1d5",
    strip_prefix = "rules_js-1.41.2",
    url = "https://github.com/aspect-build/rules_js/releases/download/v1.41.2/rules_js-v1.41.2.tar.gz",
)

load("@aspect_rules_js//js:repositories.bzl", "rules_js_dependencies")

rules_js_dependencies()

load("@bazel_features//:deps.bzl", "bazel_features_deps")

bazel_features_deps()

load("@aspect_rules_js//npm:npm_import.bzl", "npm_translate_lock", "pnpm_repository")

pnpm_repository(name = "pnpm")

http_archive(
    name = "aspect_rules_esbuild",
    sha256 = "999349afef62875301f45ec8515189ceaf2e85b1e67a17e2d28b95b30e1d6c0b",
    strip_prefix = "rules_esbuild-0.18.0",
    url = "https://github.com/aspect-build/rules_esbuild/releases/download/v0.18.0/rules_esbuild-v0.18.0.tar.gz",
)

load("@aspect_rules_esbuild//esbuild:dependencies.bzl", "rules_esbuild_dependencies")

rules_esbuild_dependencies()

load("@rules_nodejs//nodejs:repositories.bzl", "DEFAULT_NODE_VERSION", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "nodejs",
    node_version = DEFAULT_NODE_VERSION,
)

npm_translate_lock(
    name = "npm",
    data = [
        "@aos//:package.json",
        "@aos//:pnpm-workspace.yaml",
        "@aos//aos/analysis/foxglove_extension:package.json",
        "@aos//control_loops/swerve/spline_ui/www:package.json",
        "@aos//scouting/webserver/requests/messages:package.json",
        "@aos//scouting/www:package.json",
        "@aos//scouting/www/driver_ranking:package.json",
        "@aos//scouting/www/entry:package.json",
        "@aos//scouting/www/match_list:package.json",
        "@aos//scouting/www/notes:package.json",
        "@aos//scouting/www/pipes:package.json",
        "@aos//scouting/www/rpc:package.json",
        "@aos//scouting/www/scan:package.json",
        "@aos//scouting/www/shift_schedule:package.json",
        "@aos//scouting/www/test/authorize:package.json",
        "@aos//scouting/www/view:package.json",
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
    pnpm_lock = "@aos//:pnpm-lock.yaml",
    quiet = False,
    update_pnpm_lock = False,
    verify_node_modules_ignored = "@aos//:.bazelignore",
)

load("@aspect_rules_esbuild//esbuild:repositories.bzl", "LATEST_ESBUILD_VERSION", "esbuild_register_toolchains")

esbuild_register_toolchains(
    name = "esbuild",
    esbuild_version = LATEST_ESBUILD_VERSION,
)

http_archive(
    name = "aspect_rules_rollup",
    patch_args = [
        "-p1",
    ],
    patches = [
        "@aos//third_party:rules_rollup/0001-Fix-resolving-files.patch",
    ],
    sha256 = "a0433a0b0206a45d362749d71bc1e4e0dacf5ca2a572b059328f9753392bca80",
    strip_prefix = "rules_rollup-1.0.0",
    url = "https://github.com/aspect-build/rules_rollup/releases/download/v1.0.0/rules_rollup-v1.0.0.tar.gz",
)

http_archive(
    name = "aspect_rules_terser",
    sha256 = "8424b4c064d0e490e5b6f215b993712ef641b77e03b68fdc64221edf48d14add",
    strip_prefix = "rules_terser-1.0.0",
    url = "https://github.com/aspect-build/rules_terser/releases/download/v1.0.0/rules_terser-v1.0.0.tar.gz",
)

load("@aspect_rules_terser//terser:dependencies.bzl", "rules_terser_dependencies")

rules_terser_dependencies()

http_archive(
    name = "aspect_rules_ts",
    sha256 = "6ad28b5bac2bb5a74e737925fbc3f62ce1edabe5a48d61a9980c491ef4cedfb7",
    strip_prefix = "rules_ts-2.1.1",
    url = "https://github.com/aspect-build/rules_ts/releases/download/v2.1.1/rules_ts-v2.1.1.tar.gz",
)

load("@aspect_rules_ts//ts:repositories.bzl", "rules_ts_dependencies")

rules_ts_dependencies(
    ts_version_from = "//:package.json",
)

load("@npm//:repositories.bzl", "npm_repositories")

npm_repositories()

http_archive(
    name = "com_google_absl",
    patch_args = ["-p1"],
    patches = ["@aos//third_party/abseil:abseil.patch"],
    sha256 = "733726b8c3a6d39a4120d7e45ea8b41a434cdacde401cba500f14236c49b39dc",
    strip_prefix = "abseil-cpp-20240116.2",
    url = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240116.2.tar.gz",
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
    sha256 = "493d9905aa09124c2f44268b66205dd013f3925a7e82995f36745974e97af609",
    strip_prefix = "grpc-1.63.0",
    url = "https://github.com/grpc/grpc/archive/refs/tags/v1.63.0.tar.gz",
)

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")

grpc_deps()

load("@com_github_grpc_grpc//bazel:grpc_extra_deps.bzl", "grpc_extra_deps")

grpc_extra_deps()
