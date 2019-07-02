#' delta_rsq
#'
#' Calculates change to R-Squared across two or more models. 
#' @param models a list of linear models. Differences will be calculated in the order models are listed. 
#' @param adjusted if FALSE (the default), non-adjusted R-Squared values are used. If TRUE, adjusted R-Squared values are used. 
#' @export

delta_rsq <- function(models, adjusted = FALSE) {
  
  # check argument length
  if (length(models) == 1) {
    stop("More than one model must be provided.")
  }
  
  # check arguments
  if (any(!vapply(models,
                  FUN       = is.list,
                  FUN.VALUE = logical(1L)))) {
    stop("All models must be of class lm and ",
         "must be listed (using `list()`).")
  }
  
  argument_check(adjusted, "adjusted", "logical", TRUE)
  
  # choose value to extract given adjusted argument
  if (adjusted == FALSE) {
    extract_val <- "r.squared"
  } else {
    extract_val <- "adj.r.squared"
  }
  
  # calculate r-squareds
  out <- vapply(models, 
                FUN       = function(x) {summary(x)[[extract_val]]},
                FUN.VALUE = double(1L))

  # calculate delta-rsquareds
  out <- diff(out)
  
  # format for output
  model_names <- deparse(substitute(models))
  model_names <- sub("list\\(", "", model_names)
  model_names <- sub("\\)$", "", model_names)
  model_names <- strsplit(model_names, ", ")

  out <- data.frame(model     = model_names[[1]],
                    delta_rsq = c(NA_real_, out))
  
  # return out
  out

} 


