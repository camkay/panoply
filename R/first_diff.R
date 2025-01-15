#' first_diff
#'
#' Takes a vector and calculates the difference between the first element and the sum of the other elements.
#' @param x a numeric vector. 
#' @export

first_diff <- function(x) {
  # check arguments
  argument_check(x, "x", "numeric", T, c(2, Inf))
  
  # calculate the difference between the first element and the sum of the other elements
  out <- x[1] - sum(x[-1], na.rm = TRUE)
  
  # remove items names
  out <- unname(out)
  
  # return out
  out
}
