#' column_find
#'
#' Identifies or extracts columns in a dataframe using a string. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param return a string specifying the output desired. "logical" (the default) returns a logical vector with TRUE indicating that a column name includes the pattern. "numeric" returns a numeric vector that identifies the column numbers matching the pattern. "character" returns a character vector with the column names that match the pattern. "data.frame" returns a data frame that includes only those columns whose names match the pattern.
#' @param invert if TRUE, identifies or extracts columns that DO NOT match the pattern.
#' @param antipattern an optional character string that is used to identify columns that should not be returned. It can be a regular expression.
#' @export
#' @examples
#' x <- data.frame(my_column_x  = 1:10,
#'                 my_column_x2 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_x3 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_y  = 11:20,
#'                 my_column_y2 = 11:20 * rnorm(10, mean = 1),
#'                 my_column_y3 = 11:20 * rnorm(10, mean = 1))
#' 
#' column_find(pattern = "x", data = x, return = "logical")
#' column_find(pattern = "x", data = x, return = "numeric")
#' column_find(pattern = "x", data = x, return = "character")
#' column_find(pattern = "x", data = x, return = "data.frame")
#' 

column_find <- function(pattern, data, return = "logical", invert = FALSE, antipattern) {
  
  # check arguments
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(data, "data", "data.frame")
  argument_check(return, "return", "character", len_check = TRUE)
  argument_check(invert, "invert", "logical", len_check = TRUE)
  if (!missing(antipattern)) argument_check(antipattern, 
                                            "antipattern", 
                                            "character", 
                                            len_check = TRUE)
  return <- choice_check(return, "return type", c("logical", 
                                                  "numeric",
                                                  "character",
                                                  "data.frame"))
  
  # identify columns
  if (invert == FALSE) {
    out <- grepl(pattern, names(data))
    if (!missing(antipattern)) out <- out &!grepl(antipattern, names(data))
  } else {
    out <- !grepl(pattern, names(data))
    if (!missing(antipattern)) out <- out &!grepl(antipattern, names(data))
  }
  
  # format x for output
  if (return == "numeric") {
    out <- which(out)
  } else if (return == "character" ) {
    out <- colnames(data)[out]
  } else if (return == "data.frame") {
    out <- data[, out]
  } 
  
  
  # return out
  out
}
