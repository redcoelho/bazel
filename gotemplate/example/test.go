package example

import (
	"os"
	"testing"
)

// Check generated output equals expected content.
func TestFile(t *testing.T) {
	in, err := os.ReadFile("in.go")
	if err != nil {
		t.Errorf("failed to read generated file: %v", err)
	}

	out, err := os.ReadFile("out.go")
	if err != nil {
		t.Errorf("failed to read out file: %v", err)
	}

	if got, want := string(in), string(out); got != want {
		t.Errorf("got = \n%s\n\nwant =\n%s", got, want)
	}
}

// Check generated code is usuable.
func TestCode(t *testing.T) {
	if got, want := Foo(), "foo"; got != want {
		t.Errorf("got = %q, want = %q", got, want)
	}
}
