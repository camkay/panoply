#' italic_tex
#'
#' A function for easily formatting strings as bold or italicized using markdown or LaTeX syntax. `bold(x)` is a shortcut for `text_format(x, format = "bold", latex = FALSE)` and `italic(x)` is a shortcut for `text_format(x, format = "italic", latex = FALSE)`. `bold_tex(x)` is a shortcut for `text_format(x, format = "bold", latex = TRUE)` and `italic_tex(x)` is a shortcut for `text_format(x, format = "italic", latex = TRUE)`. 
#' 
#' @param x a character scalar or vector to be formatted. 
#' @param format a string specifying whether the text should be boled or italicized. 
#' @param latex if TRUE, text is formatted using LaTeX formatting. 
#' @export

italic_tex <- function(x) {
  text_format(x, format = "italic", latex = TRUE)
}
