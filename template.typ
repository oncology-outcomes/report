// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let unescape-eval(str) = {
  return eval(str.replace("\\", ""))
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}

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

#show: doc => report(
   title: [Example report], 
   subtitle: [Oncology Outcomes (O2)], 
   date: [2024-11-15], 
   lang: "en", 
  
  
  
   font: ("Narin",), 
   fontsize: 12pt, 
  
   toc_title: [Table of contents], 
  
   toc_depth: 3, 
  
  
  
  
  doc,
)

= Introduction
<introduction>
= Methods
<methods>
= Results
<results>
= Summary
<summary>




