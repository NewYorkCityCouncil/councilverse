#' Function to retrieve acs estimates from csvs at different geographies
#'
#'
#' @param name Name of the csv. If NULL, returns a list of possible geography csvs.
#' @import dplyr
#' @return sf for the specified geography, or list of geographies if none is specified
#' @export
#'

get_geo_estimates <- function(name = NULL) {

  csv_names <- dir(system.file("extdata", package = "councilverse"))
  geo_csv_names <- csv_names[grepl("geographies", csv_names)]

  if (is.null(name)) {
    geo_csv_names
  } else {
    readr::read_csv(fs::path_package("extdata", name, package = "councilverse")) %>%
      janitor::clean_names() %>%
      sf::st_as_sf(wkt = "geometry", crs = 4326) %>%
      st_transform("+proj=longlat +datum=WGS84")
  }
}
