#show: doc => report(
  $if(title)$ title: [$title$], $endif$
  $if(subtitle)$ subtitle: [$subtitle$], $endif$
  $if(date)$ date: [$date$], $endif$
  $if(lang)$ lang: "$lang$", $endif$
  $if(region)$ region: "$region$", $endif$
  $if(margin)$ margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$), $endif$
  $if(papersize)$ paper: "$papersize$", $endif$
  $if(mainfont)$ font: ("$mainfont$",), $endif$
  $if(fontsize)$ fontsize: $fontsize$, $endif$
  $if(toc)$ toc: $toc$, $endif$
  $if(toc-title)$ toc_title: [$toc-title$], $endif$
  $if(toc-indent)$ toc_indent: $toc-indent$, $endif$
  $if(toc-depth)$ toc_depth: $toc-depth$, $endif$
  $if(lof)$ lof: $lof$, $endif$
  $if(lof-title)$ lof_title: [$lof-title$], $endif$
  $if(lot)$ lot: $lot$, $endif$
  $if(lot-title)$ lot_title: [$lot-title$], $endif$
  doc,
)
