#' supers
#'
#' A function for easily formatting a string as a superscript
#' 
#' @param x a character scalar or vector to be formatted. 
#' @export

supers <- function(x) {
  text_format(x, format = "super", latex = FALSE)
}