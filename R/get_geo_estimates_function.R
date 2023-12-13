#' Function to retrieve acs estimates from csvs at different geographies
#'
#'
#' @param geo (string). Name of the geography with associated csv in "extdata". If NULL, returns a list of possible geography csvs. Options: "borough", "community", "council", "neighborhood", "precinct", "schooldist".
#' @param boundary_year (string). Year for the geographic boundary (i.e. geo). Currently only relevant for council districts, which have the options "2013" and "2023".
#' @import dplyr
#' @return sf for the specified geography, or message with list of geographies if none is specified
#' @export
#'

get_geo_estimates <- function(geo = NULL, boundary_year = NULL) {

  csv_names <- dir(system.file("extdata", package = "councilverse"))
  geo_csv_names <- csv_names[grepl("geographies", csv_names)]
  geo_names <- stringr::str_extract(geo_csv_names, "[^-]+")

  if (is.null(geo)) {
    message("get_geo_estimates() requires a 'geo' parameter.", "\n",
            "Please choose from the following:\n",
            paste0('"',geo_names, '"', collapse = "\n"))
  } else if (!(geo %in% geo_names)) {
    message("This geography could not be found", "\n",
            "Please choose from the following:\n",
            paste0('"',geo_names, '"', collapse = "\n"))
  }
  else {
    boundary_year_cut <- stringr::str_sub(boundary_year, -2)
    boundary_year_ext <- ifelse(is.null(boundary_year), "", glue::glue("_b{boundary_year_cut}"))
    # only year used so far is 2021
    readr::read_csv(fs::path_package("extdata", glue::glue("{geo}-geographies{boundary_year_ext}_2021.csv"), package = "councilverse")) %>%
      janitor::clean_names() %>%
      sf::st_as_sf(wkt = "geometry", crs = 4326) %>%
      sf::st_transform("+proj=longlat +datum=WGS84")
  }
}
