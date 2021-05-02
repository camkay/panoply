#' column_alpha
#'
#' Estimates Cronbach's Alpha--an indicator of internal consistency--using only columns that have names that match a pattern. The analysis relies on `psych::alpha`. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param full if TRUE, the full results of the reliability analysis produced by the `psych` package is returned. If FALSE, only the raw alpha value is returned.
#' @param verbose specifies whether all column names used should be listed in the message, regardless of length. 
#' @param message if TRUE, messages are generated telling the user which columns were used to calculate Cronbach's Alpha.
#' @param na.rm a logical value indicating whether `NA` values should be removed prior to computation.
#' @param rij a logical value indicating whether the average correlation between the items should be returned instead of Cronbach's alpha. 
#' @param ... additional arguments passed to `column_alpha`.
#' @export
#' 

column_alpha <- function(pattern, 
                         data, 
                         full    = FALSE, 
                         verbose = FALSE,
                         message = TRUE,
                         na.rm   = TRUE,
                         rij     = FALSE) {
  
  # check arguments
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(data, "data", "data.frame")
  argument_check(full, "full", "logical", len_check = TRUE)
  argument_check(message, "message", "logical", len_check = TRUE)
  argument_check(na.rm, "na.rm", "logical", len_check = TRUE)
  
  # find columns that match the pattern
  data_found <- column_find(pattern, data, return = "data.frame")
  
  # message user how the composites were created if message == TRUE
  if (rij) {
    message_value <- "An average inter-item correlation"
  } else {
    message_value <- "Cronbach's Alpha"
  }

  if (message == TRUE) {
    column_message(data_found, message_value, verbose = verbose)
  }

  # calculate and extract the alpha value
  alpha_out <- psych::alpha(x = data_found, na.rm = na.rm, warnings = FALSE)
  
  # return only raw alpha if FULL == FALSE
  if (full == FALSE) {
    # return RIJ if rij == TRUE
    if(rij) {
      alpha_out <- alpha_out[["total"]][["average_r"]]  
    } else{
      alpha_out <- alpha_out[["total"]][["raw_alpha"]]  
    }
  } 
  
  # return alphas
  alpha_out

}

#' @rdname column_alpha
#' @export

column_rij <- function(pattern, data, ...) {
  column_alpha(pattern = pattern, 
               data    = data, 
               rij     = TRUE,
               ...)
}
