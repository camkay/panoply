#' column message
#'
#' A function for creating messages when an action is performed on the results of column_find. 
#' @param data the results of column_find.
#' @param function_operation the operation to be performed on the results of column_find. 
#' @param verbose specifies whether all column names should be listed, regardless of length. 


column_message <- function(data, function_operation, verbose = FALSE) {
  
  # calculate number of columns
  num_cols <- ncol(data)
  
  # stop the function if no columns are returned or specify column names
  if (num_cols == 0) {
    stop("No columns matched the provided string.")
  } else if (num_cols > 4 & verbose == FALSE) {
    col_names <- paste0(paste(names(data)[1:3], collapse = ", "), ", and ", num_cols - 3, " more")
  } else {
    col_names <- paste(names(data), collapse = ", ")
  }
  
  message(paste0(function_operation,
                " was calculated using ", 
                num_cols, 
                " columns: ",
                col_names,
                "."))
}


