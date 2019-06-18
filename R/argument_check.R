#' Argument Check
#'
#' A function for streamlining the argument-checking process. It is not exported. 
#' @param x an argument.
#' @param name the name of the argument.
#' @param type a string indicating what type the argument should be.
#' @param length_check a logical scalar indicating whether the argument should be checked for length.
#' @param length_req a numeric scalar indicating the required length for the argument. 
#' @param coerce a logical scalar indicating whether an argument should be coerced to a given type.


argument_check <- function(x, 
                           name, 
                           type, 
                           length_check = FALSE, 
                           length_req   = 1,
                           coerce       = FALSE) {
  
  # create type_check function for testing and type_coerce for coercing
  type_check  <- get(paste0("is.", type))
  type_coerce <- get(paste0("as.", type))
  
  # check if x is of the correct type
  if (!type_check(x)) {
    
    # if coerce == TRUE, check whether x can be coerced
    if (coerce == TRUE) {
      # check if x is of a coercible type
      coerced <- type_coerce(x)
    
      # if the result of the coercion is na, stop the function
      if (any(is.na(coerced))) {
        message_stop <- paste0(name, " is of type ", typeof(x), " and could not be coerced to type ", type, ".")
      }
    
      # inform user that x was coerced
      message_warn <- paste0(name, " was coerced to type ", type, ".")
      
      # return coerced values
      x <- coerced
      
    } else {
      message_stop <- paste0(name, " is of type ", typeof(x), ". ", name, " must be of type ", type, ".")
    }
  }
  
  # check if x is of the correct length (if length_check is specified)
  if (length_check) {
    if (length(x) != length_req) {
      message_stop <- paste0(name, " must be of length ", length_req, ". ", name, " is of length ", length(x), ".")
    }
  }
  
  # if all goes as planned, return x
  
}
    


argument_check(c(TRUE, TRUE), "x", "logical", coerce = TRUE)
