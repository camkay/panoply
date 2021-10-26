#' spround
#'
#' Round and specify knitted decimal places all in one step.
#' @param x a numeric/character scalar or vector.
#' @param digits a numeric scalar indicating the number of decimal places to round to.
#' @param leading0 a logical scalar indicating whether leading zeros should be included.
#' @param less_than a logical scalar indicating whether rounded values equal to zero should be represented as less than a certain value (e.g., 0.000 becomes < .001). 
#' @export
#' @examples
#' spround(x = c(0.1078, 9.9930, 42.4242), digits = 2, leading0 = TRUE)
#' spround(x = c(0.1078, 9.9930, 42.4242), digits = 2, leading0 = FALSE)

spround <- function(x, digits = 2, leading0 = TRUE, less_than = FALSE) {
  
  # check arguments
  argument_check(x,               "x", "numeric")
  argument_check(digits,     "digits", "numeric", len_check = TRUE)
  argument_check(leading0, "leading0", "logical", len_check = TRUE)

  # round x to the number of digits requested
  out <- round(x, digits)
  
  # format the number for knitting
  out <- sprintf(paste0("%.", digits, "f"), out)
  
  # if less_than == TRUE, replace values equivaelent to zero
  if (less_than == TRUE) {
    if (digits != 0) {
      out[as.numeric(out) == 0] <- paste0("< 0.",
                                          paste(rep("0", digits - 1), collapse = ""),
                                          "1")
    } else {
      out[as.numeric(out) == 0] <- paste0("< 1")
    }
  }

  # if leading0 == FALSE, drop the leading zero
  if (leading0 == FALSE) {
    out[grepl("^(|-|< )0", out)]  <- sub("0", "", out[grepl("^(|-|< )0", out)])
  }
  
  # return x
  return(out)
}
