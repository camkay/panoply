#' centre
#'
#' Centers a numeric vector. It is identical to running `scale(x, center = TRUE, scale = FALSE)`.
#' @param x a numeric vector or similar.

centre <- function(x) {
  
  # center variable
  scale(x, center = TRUE, scale = FALSE)
  
}

center <- centre
