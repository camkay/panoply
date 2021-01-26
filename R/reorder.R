#' reorder
#'
#' Reorders columns based on a string with separators. Defaults to splitting using "\\|", because that is what is used by qualtrics. 
#' @param data a data frame. 
#' @param key a character string indicating the order of the columns. It IS case sensitive. 
#' @param sep a character string indicating the symbol that is used to split the column names. Defaults to "\\|" because that is what is used by Qualtrics.
#' @export
#' 

reorder <- function(data, key, sep = "\\|") {
  
  # check arguments
  argument_check(data, "data", "data.frame")
  argument_check(key, "key", "character", len_check = TRUE)
  argument_check(sep, "sep", "character", len_check = TRUE)
  
  # separate string by separation
  key <- strsplit(key, sep)[[1]]
  
  if(length(key) == 1) stop("reorder was unable to split the key", 
                            " using sep.") 
  
  # reorder the columns
  out <- tryCatch(data[, key], error = function(x) {
    stop("could not find key labels in provided dataframe.")
  })
  
  # return out
  out
}

         