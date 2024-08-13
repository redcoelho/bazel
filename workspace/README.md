# Rules

## workspace_path

```
workspace_path(name)
```

Writes the full path of the current workspace.

Required by the [go_template](../gotemplate/README.md) rule.


### Attributes

| Name | Description | Type | Mandatory | Default |
| ---- | ----------- | ---- | --------- | ------- |
| name | A unique name for this target. | [Name](https://bazel.build/concepts/labels#target-names) | required | "" |
