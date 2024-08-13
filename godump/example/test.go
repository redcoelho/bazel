package example

import (
	"os"
	"testing"
)

// Check generated output equals expected content.
func TestFile(t *testing.T) {
	tests := []struct {
		in  string
		out string
	}{
		{"test_dump.sh", "out.sh"},
	}
	for _, test := range tests {
		in, err := os.ReadFile(test.in)
		if err != nil {
			t.Errorf("failed to read generated file %q: %v", test.in, err)
		}

		out, err := os.ReadFile(test.out)
		if err != nil {
			t.Errorf("failed to read out file %q: %v", test.out, err)
		}

		if got, want := string(in), string(out); got != want {
			t.Errorf("%q: got = \n%s\n\nwant =\n%s", test.in, got, want)
		}
	}
}
