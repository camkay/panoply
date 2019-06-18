#' column_alpha
#'
#' Estimates Cronbach's Alpha--an indicator of internal consistency--using only columns that have names that match a pattern. The analysis relies relies on `psych::alpha`. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param full if TRUE, the full reliability analysis produced by the `psych` package is returned. If FALSE, only the raw alpha value is returned.
#' @param verbose specifies whether all column names should be listed, regardless of length. 
#' @export
#' @examples
#' x <- data.frame(my_column_x  = 1:10,
#'                 my_column_x2 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_x3 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_y  = 11:20,
#'                 my_column_y2 = 11:20 * rnorm(10, mean = 1),
#'                 my_column_y3 = 11:20 * rnorm(10, mean = 1))
#' 
#' column_alpha(pattern = "x", data = x, full = TRUE)
#' column_alpha(pattern = "x", data = x, full = FALSE)
#' 

column_alpha <- function(pattern, data, full = FALSE, verbose = FALSE, na.rm = TRUE) {
  
  # check arguments
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(data, "data", "data.frame")
  argument_check(full, "full", "logical", len_check = TRUE)
  argument_check(na.rm, "na.rm", "logical", len_check = TRUE)
  
  # find columns that match the pattern
  data_found <- column_find(pattern, data, return = "data.frame")
  
  # message user how the composites were created
  column_message(data_found, "Cronbach's Alpha", verbose = verbose)
  
  # calculate and extract the alpha value
  alpha_out <- psych::alpha(x = data_found, na.rm = na.rm, warnings = FALSE)
  
  # return only raw alpha if FULL == FALSE
  if (full == FALSE) {
    alpha_out <- alpha_out[["total"]][["raw_alpha"]]  
  } 
  
  # return alphas
  alpha_out

}
