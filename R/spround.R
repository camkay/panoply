#' spround
#'
#' Round and specify knitted decimal places all in one step.
#' @param x a numeric/character scalar or vector.
#' @param digits a numeric scalar indicating the number of decimal places to round to.
#' @param leading0 a logical scalar indicating whether leading zeros should be included.
#' @export
#' @examples
#' spround(x = c(0.1078, 9.9930, 42.4242), digits = 2, leading0 = TRUE)
#' spround(x = c(0.1078, 9.9930, 42.4242), digits = 2, leading0 = FALSE)

spround <- function(x, digits = 2, leading0 = TRUE) {
  
  # check arguments
  argument_check(x,               "x", "numeric")
  argument_check(digits,     "digits", "numeric", len_check = TRUE)
  argument_check(leading0, "leading0", "logical", len_check = TRUE)

  # round x to the number of digits requested
  out <- round(x, digits)
  
  # format the number for knitting
  out <- sprintf(paste0("%.", digits, "f"), out)
  
  # if leading0 == FALSE, drop the leading zero
  if (leading0 == FALSE) {
    out[grepl( "^0", out)]  <- sub("0", "", out[grepl( "^0", out)])
    out[grepl("^-0", out)]  <- sub("0", "", out[grepl("^-0", out)])
  }
  
  # return x
  return(out)
}

