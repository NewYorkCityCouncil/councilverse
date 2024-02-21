
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
# load last
library(councilverse)
```

## Vignette

For a demo of the 2 largest packages (`councildown` and `councilcount`)
available in `councilverse`, see `vignettes/councilverse.Rmd`

## Quick Start

First load the `councilverse` package as above.

### Councildown

The `councildown` package implements style guide compliant defaults for
R Markdown documents, `ggplot2` plots, and `leaflet` maps. For more
information, please visit the package directly:
<https://github.com/NewYorkCityCouncil/councildown/> . The
`councilverse` vignette goes through an example using most of
`councildown`’s available functions.

### Councilcount

The `councilcount` package allows easy access to ACS population data
across various geographic boundaries. For the boundaries that are not
native to the ACS, such as council districts, an estimate is provided.
For more information, please visit the package directly:

# Overview

The `councilcount` package allows easy access to population data for
around 70 demographic groups across various NYC geographic boundaries.
This data was pulled from the 2017-2021 5-Year American Community
Survey. For geographic boundaries that are not included in the ACS, like
council districts, estimates were generated.

## Installation

You can install the released version of `councilcount` from GitHub

``` r
remotes::install_github("newyorkcitycouncil/councilcount")
```

## Load Package

Note that the order of loading the libraries is important. Make sure to
load `councilcount` last.

``` r
library(tidyverse)
# load last
library(councilcount)
```

## Vignette

For demos of the functions included in `councilcount`, please visit
`vignettes/councilverse.Rmd`.

## Quick Start

First load the `councilcount` package as above.

### Functions

#### R

`councilcount` includes 3 functions:

`get_bbl_estimates()` – Generates a dataframe that provides population
estimates at the point level (there are also columns for various other
geographies, like council district) `get_census_variables()` – Provides
information on all of the ACS demographic variables that can be accessed
using `get_geo_estimates()` via variable codes `get_geo_estimates()` –
Creates a dataframe that provides population estimates for selected
demographic variables along chosen geographic boundaries (e.g. council
district, borough, etc.)

Simply run `get_bbl_estimates()` and `get_census_variables()` to access
the desired dataframes. They do not require any inputs.

`get_geo_estimates()` has 3 parameters:

`geo` – The desired geographic region. Please select from the following
list: \*\* Council Distrist: “councildist” \*\* Community Distrist:
“communitydist” \*\* School District: “schooldist” \*\* Police Precinct:
“policeprct” \*\* Neighborhood Tabulation Area: “nta” \*\* Borough:
“borough” `var_codes` – The desired demographic group(s), as represented
by the ACS variable code. To access the list of available demographic
variables and their codes, please run `get_census_variables()`
`boundary_year` – If “councildist” is selected, the boundary year must
be specified as 2013 or 2023. The default is 2013.

Here is an example, in which codes for “Female” and “Adults with
Bachelor’s degree or higher” are used. The data is requested along 2023
Council District boundaries.

``` r
vars <- c('DP05_0003PE', 'DP02_0068E')
get_geo_estimates(geo = "councildist", var_codes = vars, boundary_year = "2023") 
```

#### Python

The equivalent functions are also available in Python. To access them,
use the following code:

``` python
import sys
# set absolute path to councilverse/inst/python location
sys.path.insert(0, "/{YOUR PATH}/councilverse/inst/python")
from retrieve_estimates import get_bbl_estimates, get_census_variables, get_geo_estimates
```

`get_bbl_estimates()` and `get_census_variables()` function the same in
both R and Python. However, `get_geo_estimates()` has some differences
in Python. Instead of having separate parameters for geo and boundary
year, there are two input options for Council Districts, “councildist13”
and “councildist23.” Data for New York City as a whole is also available
using “nyc” for geo. Otherwise, the geo input options are the same.
There are also two additional parameters, `polygons` and `download`,
with the defaults set at False. If `polygons` is set to True, the
dataframe will include a column with the geometries associated with each
geographic region. If `download` is set to True, the dataframe will
automatically download as a CSV when the function runs.

### Other Functions

The following functions are standalone functions in `councilverse` used
in more niche situations.

#### Graphs and Tables

`encodeGraphic()` helps convert images to raw HTML. This is useful for
adding extra graphics to any HTML element in visualizations.
`gt_table()` similarly converts `gt` outputs to raw HTML.

An example of both these functions being used can be found in the NYCHA
Scrape repo:
<https://newyorkcitycouncil.github.io/NYCHA_Scrape/visualization/heat_outage_scatter.html>

#### Misc

`file_name_generator()` creates file names using accepted guidelines
detailed in the function’s documentation.

``` r
# All fields used
file_name_generator(order = "01", description = "acs_poverty", time_granularity = "daily", disaggregation_categories = c("cd", "race"), date_year = 2018, file_extension = ".R",... = "example")
#> [1] "01_acs-poverty_daily_by-cd-race_2018_example.R"
```

`unzip_sf()` loads in shapefiles that come originally as zip files.

``` r
url <- "https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nyct2020_22a.zip"
# unzip the zip file
zip <- unzip_sf(url)
# assign to variable with read_csv or other read functions
sf <- sf::read_sf(zip)
```
