package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"text/template"
)

var (
	templateFile string
	outputFile   string
	args         string
)

func main() {
	flag.StringVar(&templateFile, "template", "", "Template file")
	flag.StringVar(&args, "args", "", "Template arguments as JSON")
	flag.StringVar(&outputFile, "out", "", "Output file")
	flag.Parse()

	if err := render(); err != nil {
		fmt.Fprintf(os.Stderr, "%+v\n", err)
		os.Exit(1)
	}
}

func render() error {
	data := make(map[string]any)
	if err := json.Unmarshal([]byte(args), &data); err != nil {
		return fmt.Errorf("failed to unmarshal args: %v", err)
	}

	b, err := os.ReadFile(templateFile)
	if err != nil {
		return fmt.Errorf("failed to read template file %q: %v", templateFile, err)
	}

	out, err := os.Create(outputFile)
	if err != nil {
		return fmt.Errorf("failed to create output file %q: %v", outputFile, err)
	}
	defer out.Close()

	tmpl, err := template.New("template").Parse(string(b))
	if err != nil {
		return fmt.Errorf("failed to parse template: %v", err)
	}

	if err := tmpl.Execute(out, data); err != nil {
		return fmt.Errorf("failed to execute template: %v", err)
	}

	return nil
}
