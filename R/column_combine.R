#' column_combine
#'
#' Creates a composite column using only columns in a data frame that have names that match a pattern. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param fun the function to use to create the composite column; defaults to `mean`. 
#' @param verbose specifies whether all column names should be listed, regardless of length. 
#' @param na.rm a logical value indicating whether `NA` values should be removed prior to computation.
#' @export
#' @examples
#' x <- data.frame(my_column_x  = 1:10,
#'                 my_column_x2 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_x3 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_y  = 11:20,
#'                 my_column_y2 = 11:20 * rnorm(10, mean = 1),
#'                 my_column_y3 = 11:20 * rnorm(10, mean = 1))
#' 
#' column_combine(pattern = "x", data = x)
#' column_combine(pattern = "_y", data = x)
#' column_combine(pattern = "my_column", data = x)

column_combine <- function(pattern, 
                           data, 
                           fun     = mean, 
                           verbose = FALSE, 
                           na.rm   = TRUE) {
  
  # check arguments
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(data, "data", "data.frame")
  argument_check(fun, "fun", "function", len_check = TRUE)
  argument_check(na.rm, "na.rm", "logical", len_check = TRUE)
  
  # find columns that match the pattern
  data_found <- column_find(pattern, data, return = "data.frame")
  
  # message user how the composites were created
  column_message(data_found, 
                 "A composite column",
                  verbose = verbose)

  # apply the function to each row
  apply(data_found, MARGIN = 1, FUN = fun)

}





