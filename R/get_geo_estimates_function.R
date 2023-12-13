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

  # use boundary year information to collect the correct csv later
  boundary_year_num <- stringr::str_sub(boundary_year, -2)
  boundary_year_ext <- dplyr::case_when(
    # ignore the boundary year if council is not the geo
    !is.null(boundary_year) & geo != "council" ~ "",
    !is.null(boundary_year) & (boundary_year != "2013" | boundary_year != "2023") & geo == "council" ~ "_b13",
    !is.null(boundary_year) & geo == "council" ~ glue::glue("_b{boundary_year_num}"),
    # default to council 2013 boundaries if council is geo and no boundary year is provided
    is.null(boundary_year) & geo == "council" ~ "_b13",
    TRUE ~ ""
  )

  if (is.null(geo)) {
    message("get_geo_estimates() requires a 'geo' parameter.", "\n",
            "Please choose from the following:\n",
            paste0('"',geo_names, '"', collapse = "\n"))
  } else if (!(geo %in% geo_names)) {
    message("This geography could not be found", "\n",
            "Please choose from the following:\n",
            paste0('"',geo_names, '"', collapse = "\n"))
  } else {
    if(!is.null(boundary_year) & geo != "council") message("`boundary_year` is only relevant for `geo = council`. Overriding boundary_year input to NULL")
    if(boundary_year != "2013" & boundary_year != "2023") message("`boundary_year` must be '2013' or '2023'. Overriding boundary_year input to 2013 if `geo = council` or NULL if `geo != council`.")
    # only year used so far is 2021
    readr::read_csv(fs::path_package("extdata", glue::glue("{geo}-geographies{boundary_year_ext}_2021.csv"), package = "councilverse")) %>%
      janitor::clean_names() %>%
      sf::st_as_sf(wkt = "geometry", crs = 4326) %>%
      sf::st_transform("+proj=longlat +datum=WGS84")
  }
}
