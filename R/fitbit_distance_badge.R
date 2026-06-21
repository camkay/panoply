#' fitbit_distance_badge
#'
#' Find the badge corresponding to a distance in miles or kilometres
#' @param x a numeric scalar representing a distance in kilometres or miles.
#' @param metric a logical scalar indicating whether `x` is a distance in kilometres (`metric = TRUE`) or miles (`metric = FALSE`). Defaults to `TRUE` (i.e., kilometres).
#' @param fitbit_only a logical scalar indicating whether only badges from Fitbit should be returned. Defaults to `FALSE`.
#' @export
#' @examples
#' fitbit_distance_badge(1000)

fitbit_distance_badge <- function(x, 
                                  metric = TRUE, 
                                  fitbit_only = FALSE) {
  
  # check arguments
  argument_check(x,                     "x", "numeric", len_check = TRUE)
  argument_check(metric,           "metric", "logical", len_check = TRUE)
  argument_check(fitbit_only, "fitbit_only", "logical", len_check = TRUE)
  
  # set fitbit dataframe
  if (fitbit_only) {
    badge_data <- subset(fitbit_distance_badges, fitbit == TRUE)
  } else {
    badge_data <- fitbit_distance_badges
  }
  
  # set metric or imperial distances
  if (metric) {
    distance <- badge_data$distances_km
  } else {
    distance <- badge_data$distances_mi
  }
  
  # find badge
  badge <- badge_data$badge[max(which(x > distance))]
  
  # return badge
  return(badge)
}
