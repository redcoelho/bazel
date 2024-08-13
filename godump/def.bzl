load("@rules_go//go:def.bzl", "GoLibrary", "GoSource", "go_context")

def append_file(dirs, files, item):
    """Appends the Bazel File to the correct list type.

    Args:
        dirs (list): List of directories.
        files (list): List of files.
        item (File): File or directory.
    """
    if item.is_directory:
        if item not in dirs:
            dirs.append(item)
    elif item not in files:
        files.append(item)

def _go_dump_impl(ctx):
    go = go_context(ctx)
    dirs = []  # List of unique directories.
    files = []  # List of unique files.
    for src in ctx.attr.srcs:
        # GoSource
        source = src[GoSource]
        for file in source.srcs:
            append_file(dirs, files, file)

        # GoLibrary
        lib = src[GoLibrary]
        source = go.library_to_source(go, struct(compiler = "", compilers = []), lib, ctx.coverage_instrumented())
        for file in source.srcs:
            append_file(dirs, files, file)

    script = ctx.actions.declare_file(ctx.attr.name + ".sh")
    ctx.actions.run_shell(
        inputs = [ctx.file.workspace] + files,
        outputs = [script],
        progress_message = "Copying files",
        command = "\n".join(
            [
                # Initiate script and log files.
                """
                echo "#!/bin/bash" > {script}
                echo "ws=$(<{workspace})" >> {script}
                chmod +x {script}
                """,
            ] + [
                # Copy source files.
                """
                echo "# File: {src_short}" >> {{script}}
                echo "install -m 644 \\$ws/{src} \\$ws/{dst}" >> {{script}}
                """.format(
                    src = f.path,
                    src_short = f.short_path,
                    dst = "/".join(f.short_path.split("/")[:-1]),
                )
                for f in files
            ] + [
                # Copy contents of source directories.
                """
                echo "# Directory: {src_short}" >> {{script}}
                echo "cp -r \\$ws/{src} \\$ws/{dst_parent}" >> {{script}}
                echo "find \\$ws/{dst} -type d -exec chmod 775 {{{{}}}} \\;" >> {{script}}
                echo "find \\$ws/{dst} -type f -exec chmod 644 {{{{}}}} \\;" >> {{script}}
                """.format(
                    src = d.path,
                    src_short = d.short_path,
                    dst = d.short_path,
                    dst_parent = "/".join(d.short_path.split("/")[:-1]),
                )
                for d in dirs
            ],
        ).format(
            script = script.path,
            workspace = ctx.file.workspace.path,
        ),
        execution_requirements = {
            "no-sandbox": "1",
            "no-remote": "1",
            "local": "1",
        },
    )

    return [DefaultInfo(
        executable = script,
        files = depset([script]),
        runfiles = ctx.runfiles(files = files),
    )]

go_dump = rule(
    doc = "Writes Bazel generated files to the workspace",
    implementation = _go_dump_impl,
    attrs = {
        "srcs": attr.label_list(
            doc = "Targets that generate Go files",
            mandatory = True,
            providers = [GoLibrary, GoSource],
        ),
        "workspace": attr.label(
            doc = "File with absolute path to the Bazel workspace",
            allow_single_file = True,
        ),
        "_go_context_data": attr.label(default = "@rules_go//:go_context_data"),
    },
    toolchains = ["@rules_go//go:toolchain"],
    executable = True,
)
