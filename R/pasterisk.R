#' pasterisk
#'
#' Returns a scalar or atomic vector of p-values and returns a scalar or atomic vector of asterisks corresponding to different significance levels.
#' @param p_vals a numeric scalar or atomic vector of p-values or effect sizes.
#' @param thresholds a numeric scalar or atomic vector of number tresholds. Defaults to .05, .01, and .001.
#' @param thresholds a character scalar to be used to indicate significance. Defaults to an asterisk (i.e., *).
#' @export


pasterisk <- function(p_vals, thresholds = c(.05, .01, .001), sig_symbol = "*") {
  # check arguments
  argument_check(p_vals, "p_vals", "numeric")
  argument_check(thresholds, "thresholds", "numeric")
  argument_check(sig_symbol, "sig_symbol", "character", len_check = TRUE)
  
  # create new vector for storing asterisks
  out <- rep("", length(p_vals))
  
  # create a second sig_symbol for applying the asterisks on greater significance
  sig_symbols <- sig_symbol

  # loop through p-values and create asterisks column
  for (i in seq_along(thresholds)) {
    out[p_vals < thresholds[i]] <- sig_symbols 
    sig_symbols <- paste0(sig_symbols, sig_symbol)
  }
  
  # return out
  out
}



