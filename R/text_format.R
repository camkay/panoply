#' text_format
#'
#' A function for easily formatting strings as bold or italicized using markdown or LaTeX syntax. `bold(x)` is a shortcut for `text_format(x, format = "bold", latex = FALSE)` and `italic(x)` is a shortcut for `text_format(x, format = "italic", latex = FALSE)`. `bold_tex(x)` is a shortcut for `text_format(x, format = "bold", latex = TRUE)` and `italic_tex(x)` is a shortcut for `text_format(x, format = "italic", latex = TRUE)`. 
#' 
#' @param x a character scalar or vector to be formatted. 
#' @param format a string specifying whether the text should be boled or italicized. 
#' @param latex if TRUE, text is formatted using LaTeX formatting. 
#' @export

text_format <- function(x, format = "italic", latex = FALSE) {
  
  # check arguments
  argument_check(format, "format", "character", len_check = TRUE)
  argument_check(latex, "latex", "logical", len_check = TRUE)
  
  if (format != "italic" & 
      format != "bold" & 
      format != "super" & 
      format != "sub"  ) {
    warning("format must be \"italic\", \"bold\", \"super\", or \"sub\". \"",
            format,
            "\" was provided. \"italic\" used instead.")
    format <- "italic"
  }
  
  # format accordingly
  if (latex == TRUE) {
    switch(format,
           "italic" = paste0("\\textit{", x, "}"),
           "bold"   = paste0("\\textbf{", x, "}"),
           "super"  = paste0("\\textsuperscript{", x, "}"),
           "sub"    = paste0("\\textsubscript{", x, "}"))
  } else {
        switch(format,
           "italic" = paste0("*", x, "*"),
           "bold"   = paste0("**", x, "**"),
           "super"  = paste0("^", x, "^"),
           "sub"    = paste0("~", x, "~"))
  }
}

#' @rdname bold if TRUE, text is formatted using LaTeX formatting. 
#' @export

bold <- function(x) {
  text_format(x, format = "bold", latex = FALSE)
}