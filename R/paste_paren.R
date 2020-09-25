#' paste_paren
#'
#' If only `x` is provided, it wraps the value in parentheses (e.g., 10.12 becomes "10.12"). If `x` and `y` are both provided, it combines the two numbers (e.g., 10.12 and 2.22) by wrapping the latter in parentheses (e.g., 10.12(2.22)). This part of the function was made to streamline the creation of tables that include cells formatted mean(sd).
#' @param x a scalar or an atomic vector. 
#' @param y a second scalar or atomic vector that will be wrapped in parentheses.
#' @export

paste_paren <- function(x, y) {
  
  if(missing(y)) {
    return(paste0("(", x, ")"))
  }
  
  # check x any y
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
  paste0(x, " (", y, ")")
}

