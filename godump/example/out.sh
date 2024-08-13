#!/bin/bash
ws=/path/to/workspace
# File: godump/example/foo.go
install -m 644 $ws/bazel-out/k8-fastbuild/bin/godump/example/foo.go $ws/godump/example
# Directory: godump/example/bar.go
cp -r $ws/bazel-out/k8-fastbuild/bin/godump/example/bar.go $ws/godump/example
find $ws/godump/example/bar.go -type d -exec chmod 775 {} \;
find $ws/godump/example/bar.go -type f -exec chmod 644 {} \;
