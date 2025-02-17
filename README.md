# Report Template

This repository contains a Quarto template for standardizing Oncology Outcomes reports. This repository is currently under active development and is liable to change substantially.

## Usage

You can use this as a template to create a report. To do this, use the following command:

```sh
quarto use template oncology-outcomes/report
```

You may also use this format with an existing Quarto project or document. From the Quarto project or document directory, run the following command to install this format:

```sh
quarto install extension oncology-outcomes/report
```

## Configuration

Below is a list of the report options that can be configured using the YAML front matter within the Quarto document.

- `title`: Title of the report.
- `toc`: Generate a table of contents. Default is `true`.
- `toc-title`: Title of the table of contents. Default is `Table of contents`.
- `toc-depth`: Header level to be included in the table of contents. Default is `3`.
- `toc-indent`: Amount to indent nested table of contents entries. Default is `1.5em`
- `lof`: Generate a list of figures. Default is `true`.
- `lof-title`: Title of the list of figures. Default is `List of figures`.
- `lot`: Generate a list of tables. Default is `true`.
- `lot-title`: Title of the list of tables. Default is `List of tables`.
