"""
Workspace rules
Copied from https://stackoverflow.com/a/65129568
"""

def _impl(ctx):
    src = ctx.file._src
    out = ctx.actions.declare_file(ctx.label.name+".txt")
    ctx.actions.run_shell(
        inputs = [src],
        outputs = [out],
        # Trim the src.short_path suffix from FULL_PATH.
        # Double braces to output literal brace for shell.
        command = """
          FULL_PATH="$(readlink -f -- "{src}")"
          echo "${{FULL_PATH%/{src_short}}}" > {out}
        """.format(
            src = src.path,
            src_short = src.short_path,
            out = out.path,
        ),
        execution_requirements = {
            "no-sandbox": "1",
            "no-remote": "1",
            "local": "1",
        },
    )
    return [DefaultInfo(files = depset([out]))]

workspace_path = rule(
    doc = "Writes the full path of the current workspace",
    implementation = _impl,
    attrs = {
        "_src": attr.label(
            allow_single_file = True,
            default = "BUILD.bazel",
        ),
    },
)
