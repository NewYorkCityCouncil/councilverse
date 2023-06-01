#' gt table to raw HTML helper function
#' 
#' Helper function to convert gt tables to raw HTML for side-by-side comparisons
#'
#' @param x gt table
#' @param currency_col add currency formatting to all columns specified
#' @param percent_col add percent formatting to all columns specified
#' @param extra_formats add any additional formatting
#' 
#' @import htmltools
#' @return Raw HTML for the gt table
#' @export
#'

gt_table <- function(x,currency_col = NA,percent_col = NA,extra_formats = NULL){
  temp <- gt(x) %>% 
    tab_options(column_labels.hidden = FALSE)
  if(!is.na(currency_col)){
    temp <- temp %>%
      fmt_currency(
        columns = {{currency_col}},
        currency = "USD"
      )
  }
  if(!is.na(percent_col)){
    temp <- temp %>%
      fmt_percent(
        columns = {{percent_col}},
        decimals = 1
      )
  }
  if(!is.null(extra_formats)){
    eval(parse(text = paste0("temp <- temp %>%",
                             extra_formats))) 
  }
  return(temp %>%
           as_raw_html())
}


#' Graphics to raw HTML
#' 
#' Helper function to convert a plot or image to raw HTML
#'
#' @param g plot or image object.
#' @param style html style, default is set to width of 150px and height of 100px
#' @param ...
#' 
#' @import htmltools
#' @return Raw HTML for the image
#' @export
#'

encodeGraphic <- function(g,style = 'style="width:150px;height:100px"',...) {
  png(tf1 <- tempfile(fileext = ".png"),...)  # Get an unused filename in the session's temporary directory, and open that file for .png structured output.
  print(g)  # Output a graphic to the file
  dev.off()  # Close the file.
  txt <- RCurl::base64Encode(readBin(tf1, "raw", file.info(tf1)[1, "size"]), "txt")  # Convert the graphic image to a base 64 encoded string.
  myImage <- htmltools::HTML(sprintf(paste('<center><img src="data:image/png;base64,%s"',' ',style,'></center>'),txt))  # Save the image as a markdown-friendly html object.
  return(myImage)
}