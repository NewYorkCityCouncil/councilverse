
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Overview

The `councilverse` is a set of packages that work in tandem to assist
the NYCC’s data team in doing their work. This package is designed to
make it easy to install and load multiple ‘councilverse’ packages in a
single step.

## Installation

You can install the released version of `councilverse` from GitHub

``` r
remotes::install_github("newyorkcitycouncil/councilverse")
```

## Load Package

Note that the order of loading the libraries is important. Make sure to
load `councilverse` last.

``` r
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
#> ✔ ggplot2 3.4.3     ✔ purrr   1.0.2
#> ✔ tibble  3.2.1     ✔ dplyr   1.1.2
#> ✔ tidyr   1.3.0     ✔ stringr 1.5.0
#> ✔ readr   2.1.2     ✔ forcats 0.5.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter()                   masks stats::filter()
#> ✖ dplyr::lag()                      masks stats::lag()
#> ✖ ggplot2::scale_color_continuous() masks councildown::scale_color_continuous()
#> ✖ ggplot2::scale_color_discrete()   masks councildown::scale_color_discrete()
#> ✖ ggplot2::scale_fill_continuous()  masks councildown::scale_fill_continuous()
#> ✖ ggplot2::scale_fill_discrete()    masks councildown::scale_fill_discrete()
# load last
library(councilverse)
```

## Vignette

For a demo of the functions available, see `vignettes/councilverse.Rmd`

## Quick Start

First load the `councilverse` package as above.

### Councilcount

\[INSERT DEMO HERE\]
