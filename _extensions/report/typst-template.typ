//  O2 branded colours
#let o2_colors = (
  blue: rgb("#006A8E"),
  green: rgb("#789D4A"),
  lightblue: rgb("#A6BBD8"),
  tan: rgb("#D2CE9E"),
  grey: rgb("#BABBB1"),
  gray: rgb("#BABBB1"),
  black: rgb("#65665C")
)

//  Calgary image for background
#let calgary_background={
  image("_extensions/report/assets/images/calgary.jpg", width: 100%, fit: "cover")
}

//  Arthur Child image for background
#let ac_background={
  image("_extensions/report/assets/images/arthur-child-gardens.jpg", height: 100%, fit: "cover")
}

//  Title page
#let title_page(title, subtitle, date)={
    page(margin: 0in, background: ac_background)[
        
        #set text(fill: white)

        #place(center + horizon, dy: -2.5in)[
            #set align(center + horizon)
            #block(width: 100%, fill: o2_colors.blue, outset: 2.5em)[
                #text(weight: "light", size: 32pt, title, top-edge: 0.3em)

                #text(weight: "bold", size: 24pt, "Oncology Outcomes (O2)")
                
                #text(weight: "light", size: 20pt, "Date: " + date)
            ]
        ]
        
        #place(center + bottom, dy: -36pt)[
            #box(width: 100%, image("_extensions/report/assets/images/o2_logo2019_horiz_tag_5in300dpi_trans.png", width: 30%), fill: white)
        ]
    ]
}

//  Back page
#let back_page()={
    set page(background: calgary_background, numbering: none)
    set text(fill: white, size: 14pt)
    place(bottom + center)[
        #text("Real-world evidence report generated by Oncology Outcomes (O2)")
        #image("_extensions/report/assets/images/o2_logo2019_emblem_5in300dpi_trans.png", width: 20%)
    ]
}

//  O2 Report format
#let report(
  title: none,
  subtitle: none,
  date: none,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "CA",
  font: ("Narin"),
  fontsize: 12pt,
  toc: true,
  toc_title: "Table of contents",
  toc_depth: 3,
  toc_indent: 1.5em,
  lof: true,
  lof_title: "List of figures",
  lot: true,
  lot_title: "List of tables",
  body,
) = {
  // Page customization
  set page(
    paper: paper,
    margin: margin,
    numbering: none,
  )

  // Header customization
  set heading(
    numbering: none
  )
  show heading.where(level: 1): set text(weight: "light", size: 24pt)
  show heading.where(level: 1): set block(width: 100%, below: 1em)
  show heading.where(level: 2): it => {
    set block(below: 1.5em)
    upper(it)
  }

  // Paragraph customization
  set par(
    leading: 0.8em,
    justify: true
  )

  // Text customization
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
    fill: black,
    hyphenate: false
  )

  // Hyperlink customization
  show link: underline
  show link: set underline(stroke: 1pt, offset: 2pt)
  show link: set text(fill: o2_colors.green)

  // Raw text/code customization
  show raw: set text(font: "Source Code Pro")
  
  // Table customization
  set table(
    align: left,
    inset: 7pt,
    stroke: (x: 0pt, y: 0.5pt)
  )
  show table.cell.where(y: 0): set text(weight: "medium")

  // Include title page if `title` present
  title_page(title, subtitle, date)

  //  Table of contents
  if toc {
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
    pagebreak(weak: true)
  }

  // Start page numbering after ToC
  set page(numbering: "1")

  //  List of figrues
  if lof {
    block(above: 0em, below: 2em)[
    #outline(
      title: lof_title,
      target: figure.where(kind: "quarto-float-fig")
    );
    ]
    pagebreak(weak: true)
  }

  //  List of tables
  if lot {
    block(above: 0em, below: 2em)[
    #outline(
      title: lot_title,
      target: figure.where(kind: "quarto-float-tbl")
    );
    ]
    pagebreak(weak: true)
  }

  body

  // Back page after rest of `doc`
  back_page()
}
