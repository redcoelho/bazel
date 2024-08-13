"""
Makes a fake go source directory for testing.
"""

load("@rules_go//go:def.bzl", "go_context")

def _impl(ctx):
    out = ctx.actions.declare_directory(ctx.attr.name + ".go")
    ctx.actions.run_shell(
        outputs = [out],
        progress_message = "Making directory",
        command = """
        mkdir -p {out}
        echo "package main" > {out}/main.go
        """.format(
            out = out.path,
        ),
    )

    go = go_context(ctx)
    out_library = go.new_library(go, srcs = [out])
    out_source = go.library_to_source(go, {}, out_library, ctx.coverage_instrumented())
    return [
        DefaultInfo(files = depset([out])),
        out_library,
        out_source,
    ]

go_fake_dir = rule(
    implementation = _impl,
    toolchains = ["@rules_go//go:toolchain"],
)