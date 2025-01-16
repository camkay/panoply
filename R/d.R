#' d
#'
#' A very simple wrapper for the `describe()` function from the `{psych}` package. In addition to having a shorter function name, it also returns fewer statistics by default.
#' @param x a numeric vector.
#' @param shorten a logical value indicating whether only the n, mean, standard deviation, minimum, and maximum should be returned. Defaults to `TRUE`.
#' @param ... additional arguments passed to `describe()`.
#' @export


d <- function(x,
              shorten = TRUE,
              ...) {
  
  # check arguments
  argument_check(x, "x", "numeric", T, c(2, Inf))
  
  # describe the data
  out <- psych::describe(x)
  
  # shorten if requested
  if (shorten) {
    out <- out[c(2:5, 8, 9)]
  }
  
  # return out
  return(out)
}


