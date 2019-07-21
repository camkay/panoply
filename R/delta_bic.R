#' delta_bic
#'
#' Calculates changes to BIC across two or more models. 
#' @param models a list of two or more linear models. Differences will be calculated in the order models are listed. 
#' @export

delta_bic <- function(models) {
  
  # check argument length
  argument_check(models, "models", "list", TRUE, c(2, Inf))
  
  # calculate BICs
  out <- vapply(models, 
                FUN       = function(model) {BIC(model)},
                FUN.VALUE = double(1L))

  # calculate delta BICs
  out <- diff(out)
  
  # format for output
  model_names <- deparse(substitute(models))
  model_names <- sub("list\\(", "", model_names)
  model_names <- sub("\\)$", "", model_names)
  model_names <- strsplit(model_names, ", ")
  
  out <- data.frame(model     = model_names[[1]],
                    delta_bic = c(NA_real_, out))
  
  # return out
  out

} 


