#' bolder
#'
#' Takes a scalar or atomic vector of effect sizes and bolds values that are equal to or larger than a specified size.
#' @param ef a numeric scalar or atomic vector of effect sizes (or any other numeric vector).
#' @param threshold a numeric scalar specifiying the size of effect size of greater to bold. Defaults to .30.
#' @param spround a logical value indicating whether values should be rounded for printing. Defaults to FALSE.
#' @param ... optional arguments passed to spround. 
#' @export


bolder <- function(ef, 
                   threshold = .30, 
                   spround   = FALSE,
                   ...) {
  # check arguments
  if (is.character(ef)) {
    ef_num <- suppressWarnings(as.numeric(ef))
    if(any(is.na(ef_num))) {
      stop("ef is of type character and could not be coerced to type numeric.")
    } else {
      warning("ef was coerced to type numeric.")
    }
  } else {
    argument_check(ef, "ef", "numeric")
    ef_num <- ef
  }
  
  argument_check(threshold, "threshold", "numeric", len_check = T, len_req = 1)
  
  # spround if TRUE
  if (spround) {
    ef <- spround(ef_num, ...)
  }
  
  # wrap the effect sizes in a bold value if greater or equal the threshold
  out <- ifelse(abs(ef_num) >= threshold, text_format(ef, "bold", TRUE), ef)

  # return out
  out
}



