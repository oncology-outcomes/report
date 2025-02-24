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

### Advanced Configuration

Typst provides considerable flexibility to control the appearance of pages and the content within pages. Most of the configuration for the appearance of the document is handled by the Typst template. However, more advanced configuration may be required to achieve the desired document structure. Raw Typst code can be included in the Quarto document to achieve these custom configurations.

One example is the ability to make tables with many columns appear on landscape pages in the output PDF. To do this, you will want to include some raw Typst code just before the code block that produces the table to flip the page to landscape, and then more raw Typst after the code block to return the subsequent pages back to their portrait orientation.

````
Here is some text in portrait orientation.

`#set page(flipped: true)`{=typst}

```{r}
generate_table()
```

`#set page(flipped: false)`{=typst}

This is some more text that should not be landscape.
````

## Known Issues

One of the known issues for moving from LaTeX based PDF genereation to Typst is producing table captions. Using Quarto, Typst, and this report template, you have to remember to include labels in the code cells that produce your tables. For example, if you were using the following code block to generate a nice table for your report, add the label and table caption options using the standard Quarto YAML.

````
```{r}
#| label: tbl-my-sweet-table
#| tbl-cap: The caption for my sweet table.
generate_table()
```
````

The label must begin with the `tbl-` prefix so that the table can be properly identified and indexed. Not that we also now use the `tbl-cap` key to provide captions rather than arguments to the table-generating function, such as with `kable()`. Also note that code block labels must be unique.
