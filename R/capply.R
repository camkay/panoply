#' capply
#'
#' A wrapper of apply for quickly applying a function to every cell of a data frame.
#' @param .data a data frame.
#' @param .f a function to be applied to every cell of the data frame. 
#' @export

capply <- function(.data, .f) {
  
  # check arguments
  argument_check(.data, ".data",     "list", len_check = FALSE)
  argument_check(.f,       ".f", "function", len_check = TRUE)

  # apply function to all cells of the data
  out <- apply(X = .data, MARGIN = c(1, 2), FUN = .f)
  
  # return out
  return(out)
}

