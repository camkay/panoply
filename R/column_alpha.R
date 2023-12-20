#' column_alpha
#'
#' Estimates Cronbach's Alpha--an indicator of internal consistency--using only columns that have names that match a pattern. The analysis relies on `psych::alpha`. 
#' @param pattern a character string that is used to find the columns of interest. It can be a regular expression.
#' @param data a data frame. 
#' @param full if TRUE, the full results of the reliability analysis produced by the `psych` package is returned. If FALSE, only the raw alpha value is returned.
#' @param verbose specifies whether all column names used should be listed in the message, regardless of length. 
#' @param message if TRUE, messages are generated telling the user which columns were used to calculate Cronbach's Alpha.
#' @param na.rm a logical value indicating whether `NA` values should be removed prior to computation.
#' @param return a string indicating whether column_alpha should return Cronbach's alpha (`"alpha"`), the average correlation between the items (`"rij"`), omega hierarchical (`"o_h"`), omega total (`"o_t"`), or all four (`"all"`). Defaults to `"alpha"`.
#' @param ci a logical value indicating whether Cronbach's alpha should be returned with Feldt et al. (1987) confidence intervals. Defaults to `FALSE`.
#' @param spround a logical value indicating whether values should be rounded for printing. Defaults to FALSE.
#' @param ... additional arguments passed to `column_alpha`.
#' @export
#' 

column_alpha <- function(pattern, 
                         data, 
                         full    = FALSE, 
                         verbose = FALSE,
                         message = TRUE,
                         na.rm   = TRUE,
                         return  = "alpha",
                         ci      = FALSE,
                         spround = FALSE) {
  
  # check arguments
  argument_check(pattern, "pattern", "character", len_check = TRUE)
  argument_check(data, "data", "data.frame")
  argument_check(full, "full", "logical", len_check = TRUE)
  argument_check(message, "message", "logical", len_check = TRUE)
  argument_check(na.rm, "na.rm", "logical", len_check = TRUE)
  argument_check(return, "return", "character", len_check = TRUE)
  argument_check(ci, "ci", "logical", len_check = TRUE)
  argument_check(spround, "spround",   "logical", TRUE, 1)
  
  return <- choice_check(return, "return", c("alpha",
                                             "rij",
                                             "o_h",
                                             "o_t",
                                             "all"))
  
  # find columns that match the pattern
  data_found <- column_find(pattern, data, return = "data.frame")

  # calculate and extract the alpha value
  if (return == "alpha" | return == "rij" | return == "all") {
    alpha_out <- psych::alpha(x = data_found, na.rm = na.rm, warnings = FALSE)
  }
  
  if (return == "o_h" | return == "o_t" | return == "all") {
      omega_tmp <- suppressWarnings(suppressMessages(psych::omega(data_found, 
                                                              plot = FALSE)))
  }
  
  # return only raw alpha if FULL == FALSE
  if (full == FALSE) {
    # return RIJ if return == "rij"
    if (return == "rij") {
      alpha_out <- alpha_out[["total"]][["average_r"]]  
    } else if (return == "alpha") {
      if (ci) {
        alpha_out <- data.frame(alpha       = alpha_out[["total"]][["raw_alpha"]],
                                alpha_lower = unname(alpha_out[["feldt"]][["lower.ci"]]),
                                alpha_upper = unname(alpha_out[["feldt"]][["upper.ci"]]))
      } else {
        alpha_out <- alpha_out[["total"]][["raw_alpha"]]
      }
    } else if (return == "o_h") {
      alpha_out <- omega_tmp$omega_h
    } else if (return == "o_t") {
      alpha_out <- omega_tmp$omega.tot
    } else {
      if (ci) {
        alpha_out <- data.frame(alpha       = alpha_out[["total"]][["raw_alpha"]],
                                alpha_lower = unname(alpha_out[["feldt"]][["lower.ci"]]),
                                alpha_upper = unname(alpha_out[["feldt"]][["upper.ci"]]),
                                rij         = alpha_out[["total"]][["average_r"]],
                                o_h         = omega_tmp$omega_h,
                                o_t         = omega_tmp$omega.tot)
      } else {
        alpha_out <- data.frame(alpha       = alpha_out[["total"]][["raw_alpha"]],
                                rij         = alpha_out[["total"]][["average_r"]],
                                o_h         = omega_tmp$omega_h,
                                o_t         = omega_tmp$omega.tot) 
      }
    }
  } 
  
  # spround if TRUE
  if (spround) {
    if (return == "all") {
      if (ci) {
        alpha_out <- data.frame(alpha       = spround(alpha_out[1, "alpha"], 2, F),
                                alpha_lower = spround(alpha_out[1, "alpha_lower"], 2, F),
                                alpha_upper = spround(alpha_out[1, "alpha_upper"], 2, F),
                                rij         = spround(alpha_out[1, "rij"], 2, F),
                                o_h         = spround(alpha_out[1, "o_h"], 2, F),
                                o_t         = spround(alpha_out[1, "o_t"], 2, F))
      } else {
        alpha_out <- data.frame(alpha = spround(alpha_out[1, "alpha"], 2, F),
                                rij   = spround(alpha_out[1, "rij"], 2, F),
                                o_h   = spround(alpha_out[1, "o_h"], 2, F),
                                o_t   = spround(alpha_out[1, "o_t"], 2, F))
      }
    } else {
      if (ci) {
        alpha_out <- data.frame(alpha       = spround(alpha_out[1, "alpha"], 2, F),
                                alpha_lower = spround(alpha_out[1, "alpha_lower"], 2, F),
                                alpha_upper = spround(alpha_out[1, "alpha_upper"], 2, F))
      } else {
        alpha_out <- spround(alpha_out, 2, F)
      }
      
    }
  }
  
  # message user how the composites were created if message == TRUE
  if (return == "rij") {
    message_value <- "An average inter-item correlation"
  } else if (return == "alpha") {
    message_value <- "Cronbach's Alpha"
  } else {
    message_value <- "Cronbach's Alpha and an average inter-item correlation"
  }

  if (message == TRUE) {
    column_message(data_found, message_value, verbose = verbose)
  }
  
  # return alphas
  alpha_out

}

#' @rdname column_alpha
#' @export

column_rij <- function(pattern, data, ...) {
  column_alpha(pattern = pattern, 
               data    = data, 
               return  = "rij",
               ...)
}

#' @rdname column_alpha
#' @export

column_all <- function(pattern, data, ...) {
  column_alpha(pattern = pattern, 
               data    = data, 
               return  = "all",
               ...)
}

#' @rdname column_alpha
#' @export

column_o_h <- function(pattern, data, ...) {
  column_alpha(pattern = pattern, 
               data    = data, 
               return  = "o_h",
               ...)
}

#' @rdname column_alpha
#' @export

column_o_t <- function(pattern, data, ...) {
  column_alpha(pattern = pattern, 
               data    = data, 
               return  = "o_t",
               ...)
}


