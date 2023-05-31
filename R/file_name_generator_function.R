#' Helper function for creating file names using accepted guidelines
#'
#' 1. Order file should be run (00-10)
#' 2. Dataset Name, Source, Location
#' 3. Time granularity (hourly, daily, minutely, yearly, etc.)
#' 4. Grouping categorizer ex ‘by-age’, ‘by-cd’, ‘by-cd-age’
#' 5. Date or Year
#' 
#' 
#' @param order (string). The sequential number in \code{##} format (if applicable) when the file is run
#' @param description (string). The dateset name, source, or location
#' @param time_granularity (string). Time granularity (e.g. 'hourly', 'daily', 'minutely', 'yearly', etc.)
#' @param disaggregation_categories (string). Grouping categorizer; accepts vectors (e.g. 'age','cd',c('age','cd'))
#' @param date_year Date or year
#' @param ... Add anything else to the back of the file name
#'
#' @return A string with the file output name
#' @export
#' @examples 
#' \dontrun{
#' # All fields used
#' file_name_generator(order = "01", description = "acs_poverty", time_granularity = "daily", disaggregation_categories = c("cd", "race"), date_year = 2018, ... = "example")
#' # Shorter example
#' file_name_generator(description = "puma_internet", date_year = 2022)
#' }

file_name_generator <- function(order = NULL,description = NULL,time_granularity = NULL,disaggregation_categories = NULL,date_year = NULL,...){
  # Clean description
  description = gsub("[ _/.&]","-",description)
  # If disaggregation_categories is a vector, paste them together with hyphens
  if(!is.null(disaggregation_categories)){
    disaggregation_categories = paste0("by-",paste(disaggregation_categories, collapse = "-"))
  }
  
  # Paste parts together
  file_name_output <- tolower(paste(order,description,time_granularity,disaggregation_categories,date_year,...,sep = "_"))
  # Clean any extra '_' due to missing arguments
  file_name_output = gsub("_{2,}","_",gsub("_$","",gsub("^_","",file_name_output)))
  
  return(file_name_output)
}
