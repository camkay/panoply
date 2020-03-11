#' profile
#'
#' Calculates the profile similarity 
#' @param data a dataset containing the two columns you wish to conduct a profile similarity analysis on.
#' @param method a string indicating the type of profile similarity analysis you wish to conduct. Defaults to "de" or double-entry q correlations.
#' @export


profile <- function(data, method = "de") {
  
  # check arguments
  argument_check(data, "data", "data.frame", len_check = TRUE, len_req = 2)
  argument_check(method, "method", "character", len_check = TRUE)
  return <- choice_check(method, "method", c("de", "r"))
  
  # set up data
  data   <- as.matrix(data)
  data   <- unname(data)
  
  # calculate profile similarity
  if (method == "de") {
    data   <- rbind(data, cbind(data[,2], data[,1]))
    m_x    <- mean(data[,1])
    m_y    <- mean(data[,2])
    sd_x   <- sd(data[,1])
    sd_y   <- sd(data[,2])
    cov_xy <- cov(data[,1], data[,2])
    num    <- 2 * cov_xy - .5 * (m_x - m_y)^2
    den    <- sd_x^2 + sd_y^2 + .5 * (m_x - m_y)^2
    out    <- num / den
  } else if (method == "r") {
    print(data[,1])
    print(data[,2])
    out <- cor(data[,1], data[,2])
  }
  
  # out
  out
}



df <- data.frame(profile_1 = c(50, 55, 60, 65, 70),
                 profile_2 = c(25, 30, 35, 40, 45))


profile(df, "r")

