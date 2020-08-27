#' reverse
#'
#' Reverse scores a value based on (1) the value (i.e., `x`), (2) the lowest possible value (i.e., `low`), and (3) the highest possible value (i.e., `high`).
#' @param x a numeric scalar to be reverse-scored.
#' @param low a numeric scalar representing the lowest possible value. Defaults to `1`.
#' @param high a numeric scalar representing the highest possible value. Defaults to `5`.
#' @export

reverse <- function(x, low = 1, high = 5) {
  # check the arguments
  argument_check(x, "x", "numeric", TRUE)
  argument_check(low,  "low",  "numeric", TRUE)
  argument_check(high, "high", "numeric", TRUE)
  
  # check that x is between low and high inclusive
  if (!any(x == low:high)) {
    stop("x (", x, ") is not a value between low (", low, 
         ") and high (", high, ") inclusive.")
  }
  
  # calculate the difference 
  dif <- (high + low) / 2
  
  # reverse score x
  x   <- x - dif
  x   <- x * -1
  x   <- x + dif
  
  # return x
  return(x)
}
