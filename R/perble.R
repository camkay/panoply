#' perble
#'
#' Extends `table` by including proportions and percentages.
#' @param x a scalar, atomic vector, or list. 
#' @param tidy by default, results are tidied into long data frame. Each group has its own row and there are four rows: group, count, proportion, and percent. If `tidy = FALSE`, a matrix is returned with count, proportion, and percent saved as row names. The group names are saved as column names. 
#' @export

perble <- function(x, tidy = TRUE){
  
  # create a table from the passed x
  out <- table(x)
  
  # calculate percentage of each member of that table
  out <- rbind(out, out / sum(as.vector(out)))
  
  # calculate percentage of each member of that table
  out <- rbind(out, out[2,] * 100)
  
  # name the rows of the table
  rownames(out) <- c("count", "proportion", "percent")
  
  # converts to data frame and formats
  if (tidy == TRUE) {
    # transpose results
    out <- t(out)
    
    # convert to a data frame
    out <- data.frame(out)
    
    # create a column with the row names and drop the row names
    out$group <- rownames(out)
    rownames(out) <- NULL
    
    # rearrange columsn so that group is first
    out <- out[, c(4, 1, 2, 3)]
    

  }
  
  # return out
  out
}


