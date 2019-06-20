#' get_paste
#'
#' A function for streamlining get(paste()). It is not exported. 
#' @param ... a list of strings to be combined and gotten.


get_paste <- function(...) {
  get(paste0(...))
}


