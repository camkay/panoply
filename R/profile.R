#' profile
#'
#' Calculates the profile similarity between two profiles. Currently only supports "de" (double-entry *q* correlations) and "r" (Pearson correlation) methods.
#' @param data a dataset containing the two columns you wish to conduct a profile similarity analysis on.
#' @param method a string indicating the type of profile similarity analysis you wish to conduct. Defaults to "de" or double-entry q correlations.
#' @param ... optional arguments to be passed to cor.
#' @export


profile <- function(data, method = "de", ...) {
  
  # check arguments
  argument_check(data, "data", "data.frame", len_check = TRUE, len_req = 2)
  argument_check(method, "method", "character", len_check = TRUE)
  method <- choice_check(method, "method", c("de", "r"))
  
  # set up data
  data   <- as.matrix(data)
  data   <- unname(data)
  
  # calculate profile similarity
  if (method == "de") {
    data <- rbind(data, cbind(data[,2], data[,1]))
    out  <- cor(data[,1], data[,2], ...) 
  } else if (method == "r") {
    out <- cor(data[,1], data[,2], ...)
  }
  
  # out
  out
}



