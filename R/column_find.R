#' column_find
#'
#' Identifies or extracts columns in a dataframe using a string. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param return a string specifying the output desired. "logical" (the default) returns a logical vector with TRUE indicating that a column name includes the pattern. "numeric" returns a numeric vector that identifies the column numbers matching the pattern. "character" returns a character vector with the column names that match the pattern. "data.frame" returns a data frame that includes only those columns whose names match the pattern.
#' @param invert if TRUE, identifies or extracts columns that DO NOT match the pattern.
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

column_find <- function(pattern, data, return = "logical", invert = FALSE) {
  
  # check arguments
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(data, "data", "data.frame")
  argument_check(return, "return", "character", len_check = TRUE)
  argument_check(invert, "invert", "logical", len_check = TRUE)
  
  # format x for output
  if (return == "logical") {
    if(invert == FALSE) {
      out <- grepl(pattern, names(data))
    } else {
      out <- !grepl(pattern, names(data))
    }
  } else if (return == "numeric") {
    out <- grep(pattern, names(data), invert = invert)
  } else if (return == "character" ) {
    out <- grep(pattern, names(data), value = TRUE, invert = invert)
  } else if (return == "data.frame") {
    out <- data[, grep(pattern, names(data), invert = invert)]
  } else {
    warning(paste0(return, 
                   " is not a recognized return type. ",
                   "\"logical\" used instead. \n", 
                   "Other return options: ",
                   "\"numeric\", \"character\", and \"data.frame\"."))
    if(invert == FALSE) {
      out <- grepl(pattern, names(data))
    } else {
      out <- !grepl(pattern, names(data))
    }
  }
  
  # return out
  out
}


