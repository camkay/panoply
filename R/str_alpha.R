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
#' str_alpha(pattern = "x", data = x, full = TRUE)
#' str_alpha(pattern = "x", data = x, full = FALSE)
#' 

str_alpha <- function(pattern, data, full = TRUE, na.rm = TRUE) {
  
  # drop columns not including the pattern
  data_found <- str_cols_find(pattern, data, return = "data")
  
  # message user what columns were used
  num_cols <- ncol(data_found)
  
  if (num_cols == 0) {
    stop("No columns matched the provided string.")
  } else if (num_cols  <= 4) {
    col_names <- paste(names(data_found), collapse = ", ")
  } else {
    col_names <- paste0(paste(names(data_found)[1:3], collapse = ", "), ", and ", num_cols - 3, " more")
  }
  
  message(paste0("Cronbach's Alpha was calculated using ", 
                num_cols, 
                " columns: ",
                col_names,
                "."))
  
  # calculate and extract the alpha value
  alpha_output <- psych::alpha(x = data_found, warnings = FALSE, na.rm = na.rm)
  
  # return only raw alpha if FULL == FALSE
  if (full == TRUE) {
  } else if (full == FALSE) {
    alpha_output <- alpha_output[["total"]][["raw_alpha"]]  
  } else {
    warning(paste("Full must be TRUE or FALSE. \n",
                  full, "was provided. \n",
                  "Output obtined using the default (TRUE)."))
  }
  
  # return alphas
  alpha_output

}
