# Helper function for creating file names using accepted guidelines

1.  Order file should be run (00-10)

2.  Dataset Name, Source, Location

3.  Time granularity (hourly, daily, minutely, yearly, etc.)

4.  Grouping categorizer ex ‘by-age’, ‘by-cd’, ‘by-cd-age’

5.  Date or Year

## Usage

``` r
file_name_generator(
  order = NULL,
  description = NULL,
  time_granularity = NULL,
  disaggregation_categories = NULL,
  date_year = NULL,
  file_extension = NULL,
  ...
)
```

## Arguments

- order:

  (string). The sequential number in `##` format (if applicable) when
  the file is run

- description:

  (string). The dateset name, source, or location

- time_granularity:

  (string). Time granularity (e.g. 'hourly', 'daily', 'minutely',
  'yearly', etc.)

- disaggregation_categories:

  (string). Grouping categorizer; accepts vectors (e.g.
  'age','cd',c('age','cd'))

- date_year:

  (numeric). Date or year

- file_extension:

  (string). File extension (e.g. ".csv")

- ...:

  Add anything else to the back of the file name before file extension

## Value

A string with the file output name

## Examples

``` r
if (FALSE) { # \dontrun{
# All fields used
file_name_generator(order = "01", description = "acs_poverty", time_granularity = "daily", disaggregation_categories = c("cd", "race"), date_year = 2018, file_extension = ".R",... = "example")
# Shorter example
file_name_generator(description = "puma_internet", date_year = 2022)
} # }
```
