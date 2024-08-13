# Rules

## go_dump

```
go_dump(name, srcs, workspace)
```

Writes Bazel generated files to the workspace.

Intended as an interim step for codebases that are migrating
from gomod to Bazel.

### Attributes

| Name | Description | Type | Mandatory | Default |
| ---- | ----------- | ---- | --------- | ------- |
| name | A unique name for this target. | [Name](https://bazel.build/concepts/labels#target-names) | required | "" |
| srcs | Go source files or directories | [List of labels](https://bazel.build/concepts/labels) | required | [] |
| workspace | Absolute path to workspace | [workspace_dir](../workspace/README.md) | required | "" |
