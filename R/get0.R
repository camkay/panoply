#' get0
#'
#' A function for streamlining get(paste()). It is not exported. 
#' @param ... a list of strings to be combined and gotten.


get0 <- function(...) {
  get(paste0(...))
}


