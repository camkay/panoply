#' collapse
#'
#' A shortcut of `paste(x, collapse = y)` for collapsing character vectors into a single string separated by some character. Running `collapse(c("item 1", "item 2"), sep = " + ")` is identical to running `paste(c("item 1", "item 2"), collapse = " + ")`.
#' @param vector a vector of character strings. (e.g., `c("item 1")`)
#' @param sep a character string to separate the results. Defaults to " + ".
#' @export

collapse <- function(vector, sep = " + ") {
   # check arguments
  argument_check(sep, "sep", "character", TRUE)
  
  # collapse vector
  paste(vector, collapse = sep)
}

