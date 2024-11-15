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
  image("_extensions/report/assets/images/nataliia-kvitovska-B2h9yaP9su8-unsplash.jpg", width: 100%, fit: "cover")
}

//  Page with a Calgary background
#let page_calgary(content)={
    set page(background: calgary_background)
    set text(fill: o2_colors.lightblue)
    show link: set text(fill: o2_colors.lightblue)
    show heading: set text(fill: o2_colors.lightblue)
    show heading.where(level: 1): it => {
      pagebreak()  
      it
    }
    content
  }

//  Title page
#let title_page(title, subtitle, date)={
    page(margin: 0in,
        background: image("_extensions/report/assets/images/arthur-child-gardens.jpg", height: 100%, fit: "cover"))[
        #set text(fill: white)

        #place(center + horizon, dy: -2.5in)[
            #set align(center + horizon)
            #block(width: 100%, fill: o2_colors.blue, outset: 2.5em)[
                #text(weight: "light", size: 32pt, title, top-edge: 0.3em)

                #text(weight: "bold", size: 24pt, subtitle)
                
                #text(weight: "light", size: 20pt, date)
            ]
        ]
        #place(center + bottom, dy: -36pt)[
            #box(width: 100%, image("_extensions/report/assets/images/o2_logo2019_horiz_tag_5in300dpi_trans.png", width: 30%), fill: white)
        ]
    ]
}

//  Back page
#let back_page()={
  page_calgary()[
      #set page(background: calgary_background, numbering: none)
      #set text(fill: white, size: 16pt)
      #show link: set text(fill: white)
      #show par: set block(spacing: 0.5em)
      #place(bottom + center)[
        
          Report prepared by Oncology Outcomes (O2).

          #image("_extensions/report/assets/images/o2_logo2019_emblem_5in300dpi_trans.png", width: 20%)

        ]
      ]
}

//  Report format
#let report(
  title: none,
  subtitle: none,
  date: none,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 12pt,
  toc: true,
  toc_title: "Table of contents",
  toc_depth: 3,
  toc_indent: 1.5em,
  lof: true,
  lof_title: "List of figures",
  lot: true,
  lot_title: "List of tables",
  doc,
) = {
  
  set page(
    paper: paper,
    margin: margin,
    numbering: none,
  )

  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
    fill: black
  )

  set par(
    leading: 0.8em
  )
  
  set table(
    align: left,
    inset: 7pt,
    stroke: (x: none, y: 0.5pt)
  )

  if title != none {
    title_page(title, subtitle, date)
  }

  show heading.where(level: 1): set text(weight: "light", size: 24pt)
  show heading.where(level: 1): set block(width: 100%, below: 1em)
  
  show heading.where(level: 2): it => {
    set block(below: 1.5em)
    upper(it)
  }

  show link: underline
  show link: set underline(stroke: 1pt, offset: 2pt)
  show link: set text(fill: o2_colors.green)

  show raw: set text(font: "Source Code Pro")

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

  doc

  back_page()
}
