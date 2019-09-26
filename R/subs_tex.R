#' subs_tex
#'
#' A function for easily formatting a string as a subscript in LaTeX. 
#' 
#' @param x a character scalar or vector to be formatted. 
#' @export

subs_tex <- function(x) {
  text_format(x, format = "sub", latex = TRUE)
}

