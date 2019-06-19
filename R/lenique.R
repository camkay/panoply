#' lenique
#'
#' A very simple wrapper that calculates the length of unique values in a vector in one step. It is identical to running `length(unique(x))`.`
#' @param x a scalar, atomic vector, or list. 
#' @export

lenique <- function(x) {
  # calculate the length of unique values
  length(unique(x))
}
