#' d
#'
#' A very simple wrapper for the `describe()` function from the `{psych}` package. In addition to having a shorter function name, it also returns fewer statistics and a data.frame by default.
#' @param x a numeric vector.
#' @param shorten a logical value indicating whether only the n, mean, standard deviation, minimum, and maximum should be returned. Defaults to `TRUE`.
#' @param data_frame a logical value indicating whether an object of class `data.frame` should be returned. Defaults to `TRUE`.
#' @param ... additional arguments passed to `describe()`.
#' @export


d <- function(x,
              shorten    = TRUE,
              data_frame = TRUE,
              ...) {
  
  # check arguments
  argument_check(x, "x", "numeric", T, c(2, Inf))
  
  # describe the data
  out <- psych::describe(x)
  
  # convert to data.frame if requested
  if (data_frame) {
    out <- data.frame(out)
  }
  
  # shorten if requested
  if (shorten) {
    out <- out[c(2:5, 8, 9)]
  }
  
  # return out
  return(out)
}


