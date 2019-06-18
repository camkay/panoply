#' str_alpha
#'
#' Estimates Cronbach's Alpha--an indicator of internal consistency--using only columns that have names that match a pattern. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param full if TRUE, the full reliability analysis is returned. If FALSE, only the raw alpha value is returned.
#' @keywords cronbach's alpha
#' @keywords string
#' @export
#' @examples
#' x <- data.frame(my_column_x  = 1:10,
#'                 my_column_x2 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_x3 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_y  = 11:20,
#'                 my_column_y2 = 11:20 * rnorm(10, mean = 1),
#'                 my_column_y3 = 11:20 * rnorm(10, mean = 1))
#' 
#' str_composite(pattern = "x", data = x)
#' str_composite(pattern = "_y", data = x)
#' str_composite(pattern = "my_column", data = x)

str_composite <- function(pattern, data) {
  
  # drop columns not including the pattern
  data_found <- str_cols_find(pattern, data, return = "data")
  
  # message user how the composites were created
  num_cols <- ncol(data_found)
  
  if (num_cols == 0) {
    stop("No columns matched the provided string.")
  } else if (num_cols  <= 4) {
    col_names <- paste(names(data_found), collapse = ", ")
  } else {
    col_names <- paste0(paste(names(data_found)[1:3], collapse = ", "), ", and ", num_cols - 3, " more")
  }
  
  message(paste0("Row means were calculated using ", 
                num_cols, 
                " columns: ",
                col_names,
                "."))
  
  # calculate row means
  rowMeans(data_found)
}

str_composite("x", x)
