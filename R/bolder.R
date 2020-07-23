#' bolder
#'
#' Takes a scalar or atomic vector of effect sizes and bolds values that are equal to or larger than a specified size.
#' @param ef a numeric scalar or atomic vector of effect sizes (or any other numeric vector).
#' @param threshold a numeric scalar specifiying the size of effect size of greater to bold. Defaults to .30.
#' @export


bolder <- function(ef, threshold = .30) {
  # check arguments
  argument_check(ef, "ef", "numeric")
  argument_check(threshold, "threshold", "numeric", len_check = T, len_req = 1)
  
  # wrap the effect sizes in a bold value if greater or equal the threshold
  out <- ifelse(ef >= threshold, text_format(ef, "bold", TRUE), ef)

  # return out
  out
}

