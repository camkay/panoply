#' reorder
#'
#' Reorders columns based on a string with separators. Defaults to splitting using "\\|", because that is what is used by Qualtrics. 
#' @param data a data frame. 
#' @param key_column a character string indicating the column containing the order strings.  
#' @param sep a character string indicating the symbol that is used to split the column names. Defaults to "\\|" because that is what is used by Qualtrics.
#' @export
#' 

reorder <- function(data, key_column, sep = "\\|") {
  
  # check arguments
  argument_check(data, "data", "data.frame")
  argument_check(key_column, "key_column", "character")
  argument_check(sep, "sep", "character", len_check = TRUE)
  
  # convert data.frame from tibble
  data <- data.frame(data)
  
  # separate string by separation
  key_column <- strsplit(data[,key_column], sep)
  
  if(length(key_column[[1]]) == 1) stop("reorder was unable to split the key",
                            " using sep.")
  
  # sort every row
  out <- tryCatch(lapply(seq_along(key_column), 
                         function(i) data[i, key_column[[i]]]),
                  error = function(x) { stop("could not find key labels ",
                                             "in provided dataframe.")
                  }
                  )
  
  # return out
  out
}





         