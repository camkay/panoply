#' subs
#'
#' A function for easily formatting a string as a subscript.
#' 
#' @param x a character scalar or vector to be formatted. 
#' @export

subs <- function(x) {
  text_format(x, format = "sub", latex = FALSE)
}