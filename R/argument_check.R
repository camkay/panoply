#' argument_check
#'
#' A function for streamlining the argument-checking process. It is not exported. 
#' @param x an argument.
#' @param name the name of the argument.
#' @param type a string indicating what type the argument should be.
#' @param len_check a logical scalar indicating whether the argument should be checked for length.
#' @param len_req a numeric scalar indicating the required length for the argument. 

argument_check <- function(x, 
                           name, 
                           type, 
                           len_check = FALSE, 
                           len_req   = 1) {
  
  # create type_check function for testing
  type_check  <- get(paste0("is.", type))
  
  # stop function if it is of the incorrect type
  if (!type_check(x)) {
    stop(name,      " is of type ", typeof(x), ". ", 
         name, " must be of type ",      type,  ".")
    }
  
  # check if x is of the correct length (if len_check is TRUE)
  if (len_check) {
    if (length(len_req) == 1) {
      if (length(x) != len_req) {
        stop(name, " must be of length ", len_req, ". ",
             name,      " is of length ",  length(x), ".")
      }
    } else if (length(len_req) == 2) {
      if (length(x) < len_req[1] | length(x) > len_req[2]) {
        stop("The length of ", name, " must be between ", 
             len_req[1], " and ", len_req[2], " (inclusive). ",
             name, " is of length ",  length(x), ".")
      }
    }
  }  
}
