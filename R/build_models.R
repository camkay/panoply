#' build_models
#'
#' Creates a composite column using only columns in a data frame that have names that match a pattern. 
#' @param outcome a character string representing the outcome variable. 
#' @param predictors a list of one or more strings representing the predictors. If a vector is included in the list, the vector values are added to the model simultaneously.
#' @export


build_models <- function(outcome, predictors) {
  
  # check arguments
  argument_check(outcome, "outcome", "character", len_check = TRUE)
  argument_check(predictors, "predictors", "list", TRUE, c(1, Inf))
  
  # simplify multi-predictor additions
  predictors <- lapply(predictors,
                       function(x) {
                         if (length(x) > 1) {
                           paste(x, collapse = " + ")
                         } else {
                           x
                         }
                       })
  
  # vector for models
  out <- vector(mode = "character", length = length(predictors))
  
  # create base model
  out[[1]] <- paste0(outcome, " ~ ", predictors[[1]])
  
  # add predictors to model
  for (i in 2:length(predictors)) {
    out[[i]] <- paste0(out[[i - 1]], " + ", predictors[[i]])
  }
  
  # return output
  out
}











