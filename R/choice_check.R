#' choice_check
#'
#' A function for streamlining the argument-checking process when multiple strings are accepted. 
#' @param x an argument.
#' @param name the name of the argument
#' @param choices a vector of acceptable choices. The first string is used as the default.

choice_check <- function(x, 
                         name,
                         choices) {
  
  # check argument for choices
  if (!(x %in% choices)) {
    warning(paste0("\"",
                   x,
                   "\"",
                   " is not a recognized ",
                   name,
                   ". \"",
                   choices[1],
                   "\" used instead. \n",
                   "Other options: ",
                   paste(choices[-1], collapse = ", "),
                   "."))
    x <- choices[1]
  }
  
  # return x
  x
}
