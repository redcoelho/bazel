# Rules

## go_template

```
go_template(name, template, params)
```

This builds a [gofmt](https://pkg.go.dev/cmd/gofmt) formatted source file from a Go [template](https://pkg.go.dev/text/template). 

### Attributes

| Name | Description | Type | Mandatory | Default |
| ---- | ----------- | ---- | --------- | ------- |
| name | A unique name for this target. | [Name](https://bazel.build/concepts/labels#target-names) | required | "" |
| template | Go template file. | [File](https://bazel.build/rules/lib/builtins/File) | required | "" |
| args | Template arguments. | [Dictionary: String -> String](https://bazel.build/rules/lib/dict) | optional | {} |
| json_args | Template args in JSON format. If provided, overrides args attr. | String | optional | "" |
