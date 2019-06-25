#' delta_bic
#'
#' Calculates changes to BIC across two or more models. 
#' @param models a list of linear models. Differences will be calculated in the order models are listed. 
#' @export

delta_bic <- function(models) {
  
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
  
  # calculate r-squareds
  out <- vapply(models, 
                FUN       = function(model) {BIC(model)},
                FUN.VALUE = double(1L))

  # calculate delta AICs
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


