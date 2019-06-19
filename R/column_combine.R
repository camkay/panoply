#' column_combine
#'
#' Calculates rowwise means or sums using only columns in a data frame that have names that match a pattern. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param sum column_combine produces rowwise means by default. However, if `sum` equal TRUE, rowwise sums are produced. 
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
                           sum     = FALSE, 
                           verbose = FALSE, 
                           na.rm   = TRUE) {
  
  # check arguments
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(data, "data", "data.frame")
  argument_check(sum, "sum", "logical", len_check = TRUE)
  argument_check(na.rm, "na.rm", "logical", len_check = TRUE)
  
  # find columns that match the pattern
  data_found <- column_find(pattern, data, return = "data.frame")
  
  # message user how the composites were created
  column_message(data_found, 
                paste0("A composite column (using ",
                       ifelse(sum == FALSE, "rowMeans", "rowSums"),
                       ")"),
                  verbose = verbose)
  
  # calculate row means or row sums
  if (sum == FALSE) {
    rowMeans(data_found, na.rm = na.rm)
  } else {
    rowSums(data_found, na.rm = na.rm)  
  }
}

