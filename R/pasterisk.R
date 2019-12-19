#' pasterisk
#'
#' Takes a scalar or atomic vector of p-values and returns a scalar or atomic vector of asterisks corresponding to different significance levels.
#' @param p_vals a numeric scalar or atomic vector of p-values or effect sizes (or any other numeric vector).
#' @param thresholds a numeric scalar or atomic vector of number tresholds. Defaults to .05, .01, and .001.
#' @param sig_symbol a character scalar to be used to indicate significance. Defaults to an asterisk (i.e., *).
#' @param pad if TRUE, adds spaces to create fixed width output
#' @param pad_symbol a character scalar to be used to pad. Defaults to a space (i.e., " ").
#' @param super_script if TRUE, formats output as superscript text.
#' @export


pasterisk <- function(p_vals, 
                      thresholds   = c(.05, .01, .001), 
                      sig_symbol   = "*",
                      pad          = FALSE,
                      pad_symbol   = " ",
                      super_script = FALSE) {
  # check arguments
  argument_check(p_vals, "p_vals", "numeric")
  argument_check(thresholds, "thresholds", "numeric")
  argument_check(sig_symbol, "sig_symbol", "character", len_check = TRUE)
  argument_check(pad, "pad", "logical", len_check = TRUE)
  argument_check(super_script, "super_script", "logical", len_check = TRUE)
  
  # ensure thresholds are sorted from largest to smallest
  thresholds <- sort(thresholds, decreasing = TRUE)
  
  # create new vector for storing asterisks
  out <- rep("", length(p_vals))
  
  # create a second sig_symbol to be applied
  sig_symbols <- sig_symbol

  # loop through p-values and create asterisks column
  for (i in seq_along(thresholds)) {
    out[p_vals < thresholds[i]] <- sig_symbols 
    sig_symbols                 <- paste0(sig_symbols, sig_symbol)
  }
  
  # if pad equals TRUE, pad the asterisks with spaces
  if (pad == TRUE) {
    pad_format <- paste0("%-", length(thresholds), "s")
    out <- sprintf(pad_format, out) 
  }
  
  # if pad_symbol != " ", replace values
  if (pad_symbol != " ") {
    out <- gsub(" ", pad_symbol, out)
  }
  
  # if super_script, wrap output in textsuperscript
  if (super_script) {
    out <- supers_tex(out)
  }

  # return out
  out
}



