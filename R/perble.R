#' perble
#'
#' Extends `table` by including proportions and percentages.
#' @param x a scalar, atomic vector, or list. 
#' @param tidy by default, results are tidied into long data frame. Each group has its own row and there are four rows: group, count, proportion, and percent. If `tidy = FALSE`, a matrix is returned with count, proportion, and percent saved as row names. The group names are saved as column names. 
#' @param spround if TRUE, proportion and percent are rounded to the second decimal place.
#' @export

perble <- function(x, tidy = TRUE, spround = FALSE){
  
  # check arguments
  argument_check(tidy, "tidy", "logical", len_check = TRUE)
  argument_check(spround, "spround", "logical", len_check = TRUE)
  
  # create a table from the passed x
  out <- table(x)
  
  # calculate percentage of each member of that table
  out_prop <- out / sum(as.vector(out))
  
  # calculate percentage of each member of that table
  out_perc <- out_prop * 100
  
  # combine rows
  out <- rbind(out, out_prop, out_perc)
  
  # if spround == TRUE, round the values
  if (spround == TRUE) {
    out["out_prop", ] <- spround(out["out_prop", ], leading0 = FALSE)
    out["out_perc", ] <- spround(as.numeric(out["out_perc", ]), leading0 = TRUE)
  }
  
  # name the rows of the table
  rownames(out) <- c("count", "proportion", "percent")
  
  # converts to data frame and formats
  if (tidy == TRUE) {
    # transpose results
    out <- t(out)
    
    # convert to a data frame
    out <- data.frame(out, stringsAsFactors = FALSE)
    
    # create a column with the row names and drop the row names
    out$group <- rownames(out)
    rownames(out) <- NULL
    
    # rearrange columsn so that group is first
    out <- out[, c(4, 1, 2, 3)]
    

  }
  
  # return out
  out
}

#' @rdname perble
#' @export

p <- function(x) {
  perble(x       = x, 
         tidy    = TRUE, 
         spround = TRUE)
}


