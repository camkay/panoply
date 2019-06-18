#' scuttle
#'
#' Converts a continuous variable to categorical variable.
#' @param column a continuous numeric vector. 
#' @param split the method of splitting the continuous variable. Options include: (1) "quantile" to split the data at the 25th and 75th percentile, (2) "sd"/"sd1" to split the data at one standard deviation below and above the mean, (3) "sd2" to split the data at two standard deviations below and above the mean, (4) "sd3" to split the data at three standard deviations below and above the mean, (5) "se"/"se1" to split the data at one standard error below and above the mean, (6) "se2" to split the data at two standard errors below and above the mean, and (7) "se3" to split the data at three standard errors below and above the mean.
#' @param labels a character vector setting the names for the levels of the new categorical variable. Three levels must be provided.
#' @param greedy_extremes if `greedy_extremes == TRUE`, values at the break points are assigned to the "Low" and "High" groups instead of the "Mid" group. If `greedy_extremes == FALSE`, values at the break points are assigned to the "Mid" group instead of the "Low" and "High" group.
#' @param as.factor specifies whether the categorical variable should be coerced to a factor.
#' @param na.rm a logical value indicating whether `NA` values should be removed prior to computation. 
#' @export

scuttle <- function(column, split = "quantile", labels = c("Low", "Mid", "High"), greedy_extremes = TRUE, as.factor = TRUE, na.rm = TRUE) {

  # argument check
  argument_check(column, "column", "numeric")
  argument_check(split, "split", "character", len_check = TRUE)
  argument_check(labels, "labels", "character", len_check = TRUE, len_req = 3)
  argument_check(greedy_extremes, "greedy_extremes", "logical", len_check = TRUE)
  argument_check(as.factor, "as.factor", "logical", len_check = TRUE)
  argument_check(na.rm, "na.rm", "logical", len_check = TRUE)
  
  # ensure split can be parsed
  split_options <- c("quantile", 
                     "sd", "sd1", "sd2", "sd3",
                     "se", "se1", "se2", "se3")
  
  if (!(split %in% split_options)) {
    warning("\"",
            split,
            "\"",
            " is not one of the split options, defaulting to \"quantile\" split instead. ",
            "The available split options are: ", 
            paste0(split_options, collapse = ", "),
            ".")
    split <- "quantile"
    
  }
  
  # create new vector for storing the categorical vector
  out <- rep(NA, length(column))
  
  # calculate some simple descriptives
  c_mean <- mean(column, na.rm = na.rm)
  c_sd   <- sd(column, na.rm = na.rm)
  c_se   <- c_sd / sqrt(sum(!is.na(column)))
  c_moe  <- qnorm(.975) * c_se
  c_qs   <- quantile(column, na.rm = na.rm)
  
  # calculate break points
  breaks <- switch(split,
                   quantile = c_qs[c(2,4)],
                   sd       = c(c_mean - c_sd, c_mean + c_sd),
                   sd1      = c(c_mean - c_sd, c_mean + c_sd),
                   sd2      = c(c_mean - (c_sd * 2), c_mean + (c_sd * 2)),
                   sd3      = c(c_mean - (c_sd * 3), c_mean + (c_sd * 3)),
                   se       = c(c_mean - c_se, c_mean + c_se),
                   se1      = c(c_mean - c_se, c_mean + c_se),
                   se2      = c(c_mean - (c_se * 2), c_mean + (c_se * 2)),
                   se3      = c(c_mean - (c_se * 3), c_mean + (c_se * 3)))
  
  # cut the column using the breaks (if greedy-extremes == TRUE, break values are assigned to low/high
  if (greedy_extremes == TRUE) {
    out[column <= breaks[1]] <- labels[1]
    out[column > breaks[1] & column < breaks[2]] <- labels[2]
    out[column >= breaks[2]] <- labels[3]
  } else {
    out[column < breaks[1]] <- labels[1]
    out[column >= breaks[1] & column <= breaks[2]] <- labels[2]
    out[column > breaks[2]] <- labels[3]
  }
  
  # convert to a factor if as.factor == true
  if (as.factor == TRUE) {
    out <- factor(out, levels = labels, labels = labels)
  }

  # return out
  out
  
}

