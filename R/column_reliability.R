#' column_reliability
#'
#' Estimates Cronbach's alpha, McDonald's omega, and the average inter-item correlation using only columns that have names that match a provided pattern. The analysis relies on `MBESS::ci.reliability`. 
#' @param data a data frame. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression. Defaults to all columns in data.
#' @param return a string indicating whether the function should return Cronbach's alpha (`"alpha"`); McDonald's omega (`"omega"`); the R-C unidimensionality index (`"unidim"`); the average inter-item correlation (`"rij"`); Cronbach's alpha, the R-C unidimensionality index, and the average inter-item correlation (`"no_omega"`); or all four estimates (`"all"`). Defaults to `"all"`.
#' @param spround a logical value indicating whether values should be rounded for printing. Defaults to FALSE.
#' @param message if TRUE, messages are generated telling the user which columns were used to calculate the estimates.
#' @param verbose specifies whether all column names used should be listed in the message, regardless of length. 
#' @export
#' 

column_reliability <- function(data, 
                               pattern = "",
                               return  = "all",
                               spround = FALSE,
                               message = TRUE,
                               verbose = FALSE) {
  
  # check arguments
  argument_check(data, "data", "data.frame")
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(return, "return", "character", len_check = TRUE)
  argument_check(spround, "spround", "logical", TRUE, 1)
  argument_check(message, "message", "logical", len_check = TRUE)

  
  return <- choice_check(return, "return", c("all",
                                             "alpha",
                                             "omega",
                                             "unidim",
                                             "rij",
                                             "no_omega"))
  
  # find columns that match the pattern
  data_found <- column_find(pattern, data, return = "data.frame")

  # calculate and extract reliabilities
  if (return == "all") {
    
    alpha_out  <- MBESS::ci.reliability(data_found, type = "alpha")$est
    
    omega_out  <- MBESS::ci.reliability(data_found, type = "omega")$est
    
    unidim_out <- psych::unidim(data_found)$uni[["u"]]
    
    rij_out   <- cor(data_found)
    rij_out   <- mean(rij_out[lower.tri(rij_out)])
    
    if (spround) {
      alpha_out  <- spround(alpha_out,  2, FALSE)
      omega_out  <- spround(omega_out,  2, FALSE)
      unidim_out <- spround(unidim_out, 2, FALSE)
      rij_out    <- spround(rij_out,    2, FALSE)
    }
    
    out <- data.frame(alpha  = alpha_out,
                      omega  = omega_out,
                      unidim = unidim_out,
                      rij    = rij_out)
  }
  
  if (return == "no_omega") {
    
    alpha_out <- MBESS::ci.reliability(data_found, type = "alpha")$est
    
    unidim_out <- psych::unidim(data_found)$uni[["u"]]
    
    rij_out   <- cor(data_found)
    rij_out   <- mean(rij_out[lower.tri(rij_out)])
    
    if (spround) {
      alpha_out  <- spround(alpha_out, 2, FALSE)
      unidim_out <- spround(unidim_out, 2, FALSE)
      rij_out    <- spround(rij_out,   2, FALSE)
    }
    
    out <- data.frame(alpha  = alpha_out,
                      unidim = unidim_out,
                      rij    = rij_out)
  }
  
  if (return == "alpha") {
    out <- MBESS::ci.reliability(data_found, type = "alpha")$est
    
    if (spround) {
      out <- spround(out, 2, FALSE)
    }
  }
  
  if (return == "omega") {
    out <- MBESS::ci.reliability(data_found, type = "omega")$est
    
    if (spround) {
      out <- spround(out, 2, FALSE)
    }
  }
  
  if (return == "unidim") {
    out <- psych::unidim(data_found)$uni[["u"]]
    
    if (spround) {
      out <- spround(out, 2, FALSE)
    }
  }
  
  if (return == "rij") {
    out   <- cor(data_found)
    out   <- mean(out[lower.tri(out)])
    
    if (spround) {
      out <- spround(out, 2, FALSE)
    }
  }
  
  # message user how the composites were created if message == TRUE
  if (message == TRUE) {
    
    if (return == "alpha") {
      message_value <- "Cronbach's alpha"
    } else if (return == "omega") {
      message_value <- "McDonald's omega"
    } else if (return == "unidim") {
      message_value <- "The R-C unidimensionality index"
    } else if (return == "rij") {
      message_value <- "An average inter-item correlation"
    } else {
      message_value <- "A set of reliability estimates"
    }
    
    column_message(data_found, message_value, verbose = verbose)
  }
  
  # return out
  out

}


