#' mat_merge
#'
#' Combines two matrices by drawing values from either below or above the diagonal and placing them below and above the diagonal.
#' @param x_mat a matrix.
#' @param y_mat a second matrix.
#' @param x_from if "lower" values are drawn from below the diagonal of x_mat. If "upper" values are drawn from above the diagonal of x_mat.
#' @param y_from if "lower" values are drawn from below the diagonal of y_mat. If "upper" values are drawn from above the diagonal of y_mat.
#' @param x_to if "lower" values from x_mat are placed below the diagonal. If "upper" values from x_mat are placed above the diagonal.
#' @param y_to if "lower" values from y_mat are placed below the diagonal. If "upper" values from y_mat are placed above the diagonal.
#' @export


mat_merge <- function(x_mat, 
                      y_mat, 
                      x_from = "lower",
                      y_from = "lower",
                      x_to   = "lower",
                      y_to   = "upper") {
  
  # check arguments for type
  argument_check(x_mat, "x_mat", "matrix")
  argument_check(y_mat, "y_mat", "matrix")
  argument_check(x_from, "x_from", "character", len_check = TRUE)
  argument_check(y_from, "y_from", "character", len_check = TRUE)
  argument_check(x_to, "x_to", "character", len_check = TRUE)
  argument_check(y_to, "y_to", "character", len_check = TRUE)
  
  # check arguments for acceptable placement
  if (x_from != "lower" & x_from != "upper") {
    stop("x_from must be either \"lower\" or \"upper\"")
  } else if (x_to != "lower" & x_to != "upper") {
    stop("x_to must be either \"lower\" or \"upper\"")
  } else if (y_from != "lower" & y_from != "upper") {
    stop("y_from must be either \"lower\" or \"upper\"")
  } else if (y_to != "lower" & y_to != "upper") {
    stop("y_to must be either \"lower\" or \"upper\"")
  }
  
  # check arguments for duplicate tos
  if (x_to == y_to) {
    stop("y_to cannot be placed in the same quadrant as x_to. \n",
         "One of x_to and y_to must be \"lower\"; ",
         "the other must be \"upper\".")
  }
  
  # initialize new matrix
  out_mat <- matrix(rep(0, nrow(x_mat) * ncol(x_mat)), nrow = nrow(x_mat))
  
  # duplicate matrices
  x_mat_2 <- x_mat
  y_mat_2 <- y_mat
  
  # transpose if required
  if (x_from != x_to) {
    x_mat <- t(x_mat)
  }
  if (y_from != y_to) {
    y_mat <- t(y_mat)
  }

  # place values frome existing matrices in the initialized matrix
  out_mat[get0(x_to, ".tri")(x_mat)] <- x_mat[get0(x_to, ".tri")(x_mat)]
  out_mat[get0(y_to, ".tri")(y_mat)] <- y_mat[get0(y_to, ".tri")(y_mat)]
  
  # return out_mat
  out_mat
}
