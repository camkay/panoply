#' supers_tex
#'
#' A function for easily formatting a string as a superscript in LaTeX format. 
#' 
#' @param x a character scalar or vector to be formatted. 
#' @export

supers_tex <- function(x) {
  text_format(x, format = "super", latex = TRUE)
}
