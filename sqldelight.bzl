"""provides an sqldelight compiler"""

ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

def _find_non_alpha_characters(string):
    set = {}
    for char in string.elems():
        set[char] = True
    for char in ALPHABET.elems():
        set.pop(char, False)
    return set.keys()

def _compute_module_name(ctx):
    label = ctx.label
    last_pkg = ctx.label.package.split("/").pop()
    if last_pkg == label.name:
        return "@%s//%s" % (label.workspace_name, label.package)
    else:
        return "%s" % label

def _prepare_module_name(ctx):
    if ctx.attr.module_name:
        illegal_chars = _find_non_alpha_characters(ctx.attr.module_name)
        if len(illegal_chars):
            fail(
                "Module name may only contain mixed-case alphanumeric characters without " +
                "punctuation or whitespace, but contained %s: \"%s\"" %
                (illegal_chars, ctx.attr.module_name),
            )
        return ctx.attr.module_name
    else:
        return _compute_module_name(ctx)

def _sqldelight_codegen_impl(ctx):
    srcjar = ctx.outputs.srcjar

    args = ctx.actions.args()
    args.add("-o", srcjar)

    if not ctx.attr.package_name:
        fail("SQLDelightc requires package_name to set.")
    args.add("--package_name", ctx.attr.package_name)
    module_name = _prepare_module_name(ctx)
    args.add("--module_name", "\"%s\"" % module_name)
    if ctx.attr.database_name:
        args.add("--database_name", ctx.attr.database_name)
    args.add_all(ctx.files.srcs)
    src_roots = {}
    if not len(ctx.files.srcs):
        fail("No sources found. Must specify one or more .sq files to process.")
    for f in ctx.files.srcs:
        (pre, src, rel_name) = f.short_path.partition(ctx.attr.src_dir)
        if pre == f.short_path:
            fail("Source file \"%s\" does not contain source dir \"%s\" in its path." % (
                f.short_path,
                ctx.attr.src_dir,
            ))
        src_roots[pre + src] = True  # Add to the set of roots (using dict keys as a set)
    if not len(src_roots):
        fail(
            "Could not put sources in source roots. Did you mis-specify the src_dir separator?\n" +
            "Srcs: %s\nSource Separation Dir: %s" %
            (ctx.files.srcs, ctx.attr.src_dir),
        )
    args.add_joined("--src_dirs", src_roots.keys(), join_with = ",")

    ctx.actions.run(
        executable = ctx.executable._sqldelight_compiler,
        inputs = ctx.files.srcs,
        outputs = [srcjar],
        arguments = [args],
    )
    return struct(
        providers = [
            DefaultInfo(files = depset([srcjar])),
            SqlDelightInfo(module_name = module_name),
        ],
    )

sqldelight_codegen = rule(
    _sqldelight_codegen_impl,
    attrs = {
        "_sqldelight_compiler": attr.label(
            default = Label("@rules_sqldelight//:sqldelightc"),
            executable = True,
            cfg = "host",
        ),
        "srcs": attr.label_list(allow_files = [".sq"]),
        "src_dir": attr.string(
            mandatory = True,
            doc = "root directory of the source tree, used to derived the classnames.",
        ),
        "module_name": attr.string(),
        "package_name": attr.string(),
        "database_name": attr.string(),
    },
    output_to_genfiles = True,
    outputs = {
        "srcjar": "%{name}_sqldelight.srcjar",
    },
)

SqlDelightInfo = provider(
    "Metadata about SqlDelight codegen job - typically used by tests",
    fields = {
        "module_name": "Module name passed to --module_name of sqldelightc, usually generated",
    },
)
