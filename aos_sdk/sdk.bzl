"""Rules for assembling the AOS SDK, for consumers that build with CMake.

The SDK ships in wpilib's usual artifact layout:

    headers zip   every header AOS's public libraries need (aos, flatbuffers,
                  abseil, tl::expected, and generated headers) at the root,
                  plus cmake/ and share/aos/.
    static zips   <os>/<arch>/static/libaos.a and the alwayslink archives, one
                  zip per platform.
    aos-tools     <os>/<arch>/flatc, generate and config_flattener.

The headers and their include paths are derived from CcInfo rather than
hand-listed, so this stays correct as AOS's dependencies move around.
"""

load("@rules_cc//cc/common:cc_common.bzl", "cc_common")
load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")
load("@rules_pkg//pkg:providers.bzl", "PackageFilesInfo")
load("//shared/bazel/rules:cc_rules.bzl", "CcStaticLibraryInfo")

def _include_roots(compilation_context):
    """Returns the -I/-iquote/-isystem roots, longest first.

    Both `external/<repo>/include` and `external/<repo>` can be roots. Only the
    longer one gives the path a consumer writes: `flatbuffers/base.h`, not
    `include/flatbuffers/base.h`.
    """
    roots = {}
    for inc in (compilation_context.includes.to_list() +
                compilation_context.system_includes.to_list() +
                compilation_context.quote_includes.to_list()):
        normalized = inc.rstrip("/")

        # "." and "" mean the exec root, which every path matches. Those are
        # handled by _strip_bazel_prefixes instead.
        if normalized and normalized != ".":
            roots[normalized] = True
    return sorted(roots.keys(), key = lambda root: -len(root))

def _strip_bazel_prefixes(path):
    """Turns an exec-root path into the path a consumer would #include."""
    remaining = path

    # bazel-out/<configuration>/<bin|genfiles>/...
    if remaining.startswith("bazel-out/"):
        parts = remaining.split("/")
        if len(parts) > 3:
            remaining = "/".join(parts[3:])

    # external/<repo>/...
    if remaining.startswith("external/"):
        parts = remaining.split("/")
        if len(parts) > 2:
            remaining = "/".join(parts[2:])

    return remaining

def _include_path(path, roots):
    for root in roots:
        if path.startswith(root + "/"):
            return path[len(root) + 1:]
    return _strip_bazel_prefixes(path)

_VIRTUAL_INCLUDES = "/_virtual_includes/"

def _aos_sdk_headers_impl(ctx):
    compilation_context = cc_common.merge_cc_infos(
        cc_infos = [dep[CcInfo] for dep in ctx.attr.deps],
    ).compilation_context

    excluded = {}
    for dep in ctx.attr.exclude:
        for header in dep[CcInfo].compilation_context.headers.to_list():
            excluded[header] = True

    roots = _include_roots(compilation_context)

    # A library that sets strip_include_prefix gets a `_virtual_includes`
    # symlink tree, so the same header arrives twice with two different include
    # paths and survives naive deduplication. The tree is what the library
    # publishes, so its paths win.
    canonical = {}
    relative_paths = {}
    for header in compilation_context.headers.to_list():
        if header in excluded:
            continue
        relative = _include_path(header.path, roots)
        relative_paths[header] = relative
        if _VIRTUAL_INCLUDES in header.path:
            canonical[relative] = True

    dest_src_map = {}
    for header in sorted(relative_paths.keys(), key = lambda header: header.path):
        relative = relative_paths[header]
        if relative not in canonical:
            shadowed = False
            for canonical_path in canonical.keys():
                if relative.endswith("/" + canonical_path):
                    shadowed = True
                    break
            if shadowed:
                continue

        dest = ctx.attr.prefix + "/" + relative if ctx.attr.prefix else relative
        if dest not in dest_src_map:
            dest_src_map[dest] = header

    return [
        PackageFilesInfo(dest_src_map = dest_src_map, attributes = {}),
        DefaultInfo(files = depset(dest_src_map.values())),
    ]

aos_sdk_headers = rule(
    implementation = _aos_sdk_headers_impl,
    doc = "Collects the transitive public headers of `deps`, rooted at `prefix`.",
    attrs = {
        "deps": attr.label_list(
            providers = [CcInfo],
            mandatory = True,
            doc = "Libraries whose transitive headers the SDK should ship.",
        ),
        "exclude": attr.label_list(
            providers = [CcInfo],
            doc = "Libraries whose headers another artifact already ships.",
        ),
        "prefix": attr.string(
            doc = "Directory to place the headers under. Empty means the root.",
        ),
    },
    provides = [PackageFilesInfo],
)

def _cmake_list(name, values, comment):
    lines = ["# " + line for line in comment.split("\n")]
    lines.append("set(%s" % name)
    for value in values:
        lines.append("    \"%s\"" % value)
    lines.append(")")
    return "\n".join(lines)

def _aos_sdk_cmake_settings_impl(ctx):
    defines = cc_common.merge_cc_infos(
        cc_infos = [dep[CcInfo] for dep in ctx.attr.deps],
    ).compilation_context.defines.to_list()

    ctx.actions.write(
        output = ctx.outputs.out,
        content = "\n\n".join([
            "\n".join([
                "# Generated by //aos_sdk. Do not edit.",
                "#",
                "# Everything here is read out of the Bazel build so that the CMake",
                "# side cannot drift from it.",
            ]),
            _cmake_list(
                "AOS_FLATC_ARGS",
                ctx.attr.flatc_args,
                "DEFAULT_FLATC_ARGS from aos/flatbuffers/defs.bzl. Generated\n" +
                "code is not compatible across a change here, so the SDK has to\n" +
                "invoke flatc exactly the way the Bazel rules do.",
            ),
            _cmake_list(
                "AOS_COMPILE_DEFINITIONS",
                sorted(defines),
                "The defines every AOS consumer compiles with, taken from the\n" +
                "CcInfo of //aos_sdk:aos_runtime. AOS_OS_NONE in particular is a\n" +
                "hard #error in aos/macros.h when missing.",
            ),
        ]) + "\n",
    )

    return [
        PackageFilesInfo(
            dest_src_map = {
                ctx.attr.prefix + "/" + ctx.outputs.out.basename: ctx.outputs.out,
            },
            attributes = {},
        ),
        DefaultInfo(files = depset([ctx.outputs.out])),
    ]

aos_sdk_cmake_settings = rule(
    implementation = _aos_sdk_cmake_settings_impl,
    doc = """Writes the CMake settings that have to agree with the Bazel build.

    Generating the flatc arguments and compile definitions keeps the CMake side
    from drifting out of sync with Bazel.
    """,
    attrs = {
        "deps": attr.label_list(
            providers = [CcInfo],
            mandatory = True,
            doc = "Libraries whose compilation defines consumers need.",
        ),
        "flatc_args": attr.string_list(
            mandatory = True,
            doc = "Pass DEFAULT_FLATC_ARGS from aos/flatbuffers/defs.bzl.",
        ),
        "out": attr.output(mandatory = True),
        "prefix": attr.string(
            default = "cmake",
            doc = "Directory inside the SDK to place the file under.",
        ),
    },
    provides = [PackageFilesInfo],
)

def _sanitize_label(label):
    """Turns a label into something usable as a filename."""
    result = ""
    for character in str(label).elems():
        if character.isalnum() or character == "_":
            result += character
        else:
            result += "_"
    return result.strip("_")

def _aos_sdk_alwayslink_libraries_impl(ctx):
    linking_context = cc_common.merge_cc_infos(
        cc_infos = [dep[CcInfo] for dep in ctx.attr.deps],
    ).linking_context

    dest_src_map = {}
    objects = []
    for linker_input in linking_context.linker_inputs.to_list():
        for library in linker_input.libraries:
            if not library.alwayslink:
                continue

            # Prefer the PIC variant. It links into both executables and
            # shared libraries; the non-PIC one is only safe in executables.
            archive = library.pic_static_library or library.static_library
            if archive == None:
                fail(("%s is alwayslink but exposes no static library, so its " +
                      "objects cannot be shipped in the SDK.") % linker_input.owner)

            # Named after the owning label, not the file. Basenames collide
            # across repositories and an overwrite would drop a library.
            dest = "%s/lib%s.a" % (
                ctx.attr.prefix,
                _sanitize_label(linker_input.owner),
            )
            dest_src_map[dest] = archive

            # The same choice wpilib_cc_static_library makes, so its static_deps
            # filter matches these objects.
            objects.extend(library.pic_objects if library.pic_objects else library.objects)

    return [
        PackageFilesInfo(dest_src_map = dest_src_map, attributes = {}),
        DefaultInfo(files = depset(dest_src_map.values())),
        CcStaticLibraryInfo(used_objects = depset(objects)),
    ]

aos_sdk_alwayslink_libraries = rule(
    implementation = _aos_sdk_alwayslink_libraries_impl,
    doc = """Collects the libraries that must be linked whole.

    Bazel links an `alwayslink = 1` library with --whole-archive, which is how a
    translation unit that only registers command line flags reaches the final
    binary. Rolling everything into one archive loses that, and with it flags
    like `--v` and `--vmodule` from absl/log:flags. Shipping these separately
    lets the CMake side link them whole.

    List this in a wpilib_cc_static_library's static_deps so the main archive
    does not carry a second copy of the same objects.
    """,
    attrs = {
        "deps": attr.label_list(
            providers = [CcInfo],
            mandatory = True,
            doc = "Libraries whose transitive alwayslink deps should ship.",
        ),
        "prefix": attr.string(
            mandatory = True,
            doc = "Directory to place the archives under.",
        ),
    },
    provides = [CcStaticLibraryInfo, PackageFilesInfo],
)
