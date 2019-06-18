#' str_cols_find
#'
#' Identifies columns in a dataframe using a string. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param return a string specifying the output desired. "logical" (the default) returns a logical vector with TRUE indicating that a column name includes the pattern. "numbers" returns a numeric vector that identifies the column numbers matching the pattern. "names" returns a character vector with the column names that match the pattern. "data" returns a data frame that includes only those columns whose names matched the pattern.
#' @keywords string
#' @keywords find
#' @keywords columns
#' @export
#' @examples
#' x <- data.frame(my_column_x  = 1:10,
#'                 my_column_x2 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_x3 = 1:10 * rnorm(10, mean = 1),
#'                 my_column_y  = 11:20,
#'                 my_column_y2 = 11:20 * rnorm(10, mean = 1),
#'                 my_column_y3 = 11:20 * rnorm(10, mean = 1))
#' 
#' str_cols_find(pattern = "x", data = x, return = "logical")
#' str_cols_find(pattern = "x", data = x, return = "numbers")
#' str_cols_find(pattern = "x", data = x, return = "names")
#' str_cols_find(pattern = "x", data = x, return = "data")
#' 

str_cols_find <- function(pattern, data, return = "logical") {
  
  # ensure pattern is a character and the data is a dataframe
  if (!is.character(pattern)) {
    stop("Pattern must be of type character.")
  } else if (!is.data.frame(data)) {
    stop("Data must of type dataframe/tibble.")
  }

  # format x for output
  if (return == "logical") {
    x <- grepl(pattern, names(data))
  } else if (return == "numbers") {
    x <- grep(pattern, names(data))
  } else if (return == "names" ) {
    x <- grep(pattern, names(data), value = TRUE)
  } else if (return == "data") {
    x <- data[, grep(pattern, names(data))]
  } else {
    warning(paste0(return, " is not a recognized return type. \"logical\" used instead. \n", 
                   "Other return options include: \"numbers\", \"names\", and \"data\"."))
    x <- grepl(pattern, names(data))
  }
  
  # return x
  x

}




