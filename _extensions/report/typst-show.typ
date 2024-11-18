#show: body => report(
  $if(title)$ title: [$title$], $endif$
  date: [$date$],
  toc: $toc$,
  $if(toc-title)$ toc_title: [$toc-title$], $endif$
  $if(toc-indent)$ toc_indent: $toc-indent$, $endif$
  $if(toc-depth)$ toc_depth: $toc-depth$, $endif$
  lof: $lof$,
  $if(lof-title)$ lof_title: [$lof-title$], $endif$
  lot: $lot$,
  $if(lot-title)$ lot_title: [$lot-title$], $endif$
  body,
)
