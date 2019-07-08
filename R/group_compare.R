#' group_compare
#'
#' Creates a group comparison table. It (1) calculates an overall mean and sd, as well as a mean and sd for each group, (2) runs a two-samples t-test comparing both groups, and (3) calculates Cohen's d.
#'
#' @param data a data frame. 
#' @param cols a vector of strings specifying what columns to compare.
#' @param split a string indicating the column that includes the grouping variable.
#' @param var.equal a logical value indicating whether equal variances should be assumed.
#' @param spround a logical value indicating whether values should be rounded for printing. 
#' @param collapse a logical value indicating whether means and SDs should be combined using paste_paren. 
#' @param na.rm a logical value indicating whether `NA` values should be removed prior to computation.
#' @export
#' 

group_compare <- function(data,
                          cols,
                          split, 
                          var.equal = FALSE,
                          adjust    = "none",
                          spround   = FALSE,
                          collapse  = FALSE,
                          na.rm     = TRUE) {
  
  # check arguments
  argument_check(data, "data", "data.frame")
  argument_check(cols, "cols", "character")
  argument_check(spround, "spround", "logical", len_check = TRUE)
  argument_check(collapse, "collapse", "logical", len_check = TRUE)
  argument_check(na.rm, "na.rm", "logical", len_check = TRUE)
  
  # split data using split string
  data_split <- split(data, data[, split])

  # calculate all required values
  out <- do.call(rbind, 
                 lapply(cols, function(col) {
    # calculate overall values
    overall_mean <- mean(data[, col], na.rm = na.rm)
    overall_sd   <- sd(data[, col], na.rm = na.rm)
    overall_n    <- sum(!is.na(data[, col]))
    
    # calculate group1 values
    group1_mean  <- mean(data_split[[1]][, col], na.rm = na.rm)
    group1_sd    <- sd(data_split[[1]][, col], na.rm = na.rm)
    group1_n     <- sum(!is.na(data_split[[1]][, col]))
    
    # calculate group2 values
    group2_mean  <- mean(data_split[[2]][, col], na.rm = na.rm)
    group2_sd    <- sd(data_split[[2]][, col], na.rm = na.rm)
    group2_n     <- sum(!is.na(data_split[[2]][, col]))
    
    # compare means
    t_val_num <- group1_mean - group2_mean 
    t_val_dem <- sqrt(((group1_sd^2) / group1_n) + ((group2_sd^2) / group2_n))
    t_val     <- t_val_num / t_val_dem
    if (var.equal == FALSE) {
      df_num    <- t_val_dem^4
      df_dem_l  <- (((group1_sd^2) / group1_n)^2) / (group1_n - 1)
      df_dem_r  <- (((group2_sd^2) / group2_n)^2) / (group2_n - 1)
      df        <- df_num / (df_dem_l + df_dem_r)
    } else {
      df <- overall_n - 2
    }
    p_val     <- 2 * pt(q = abs(t_val), df = df, lower = FALSE)
    d_val     <- t_val * sqrt((1 / group1_n) + (1 / group2_n))
  
    # create data.frame to return
    list(overall_m  = overall_mean, 
         overall_sd = overall_sd, 
         overall_n  = overall_n,
         group1_m   = group1_mean,
         group1_sd  = group1_sd,
         group1_n   = group1_n,
         group2_m   = group2_mean,
         group2_sd  = group2_sd,
         group2_n   = group2_n,
         t          = t_val,
         df         = df,
         p          = p_val,
         d          = d_val)
    }))

  # unlist the cells
  out <- apply(out, MARGIN = c(1, 2), unlist)

  # convert to data.frame
  out <- data.frame(out)
  
  # adjust the p values
  if  (adjust != "none") {
    out$p <- p.adjust(out$p, method = adjust)
  }

  # assign rownames to the data.frame
  rownames(out) <- cols

  # round the values if spround == TRUE
  if (spround == TRUE) {
    
    # round all values except the p-values
    temp <- apply(column_find(pattern = "^p$|^df$",
                              data    = out,
                              return  = "data.frame",
                              invert  = TRUE),
                  MARGIN = c(1, 2),
                  spround)

    out[, column_find("^p$|^df$", out,"logical", TRUE)] <- temp
    
    # round the p_values and d_values and replace .000 with <.001
    out$p  <- spround(out$p, 3, FALSE)
    out$df <- spround(out$df, 0)
    out[out$p == ".000", "p"] <- "<.001"
  }
  
  # create msd columns if collapse == TRUE
  if (collapse == TRUE) {
    # paste column values together
    out$overall_msd <- paste_paren(out$overall_m, out$overall_sd)
    out$group1_msd  <- paste_paren(out$group1_m,  out$group1_sd)
    out$group2_msd  <- paste_paren(out$group2_m,  out$group2_sd)
    
    # rearrange output
    out <- out[ , c("overall_msd",
                    "overall_n",
                    "group1_msd",
                    "group1_n",
                    "group2_msd",
                    "group2_n",
                    "t",
                    "df",
                    "p",
                    "d")]
    
  }

  # return output
  out
}


