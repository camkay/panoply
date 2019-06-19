#' paste_paren
#'
#' Combines two numbers (e.g., 10.12 and 2.22) by wrapping the latter in parentheses (e.g., 10.12(2.22)). This function was made to streamline the creation of tables that include cells formatted mean(sd).
#' @param x a scalar or an atomic vector. 
#' @param y a second scalar or atomic vector that will be wrapped in parentheses.
#' @export

paste_paren <- function(x, y) {
  
  # warn user if x and y are different lengths
  x_len <- length(x)
  y_len <- length(y)
  
  if (x_len != y_len) {
    warning("x (length = ",
            x_len,
            ") and y (length = ",
            y_len,
            ") are not of the same length. ",
            "The ",
            ifelse(length(x) > length(y), "y", "x"),
            " value(s) was/were recyled.")
  }
  
  # paste x and y together and surround with parentheses
  paste0(x, "(", y, ")")
}

