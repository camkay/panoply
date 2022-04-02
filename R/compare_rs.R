#' compare_rs
#'
#' Compares two correlations. Currently, `compare_rs()` only supports correlations that have one variable in column and that were calculated in the same sample.
#' @param x a correlation matrix object created using the `corr.test()` function from the `{psych}` package. 
#' @param cols the columns of the correlation matrix to compare.
#' @param split an optional string indicating the column that includes the grouping variable for producing different matrices above and below the diagonal.
#' @param adjust.p a string indicating what type of correction for multiple comparisons should be used. Defaults to "none."
#' @param spround a logical value indicating whether values should be rounded for printing. Defaults to TRUE.
#' @param pasterisk a logical value indicating whether p-values should be replaced with asterisks and combined with the regression coefficients. Defaults to TRUE.
#' @param bold_script if TRUE, bolds correlations over a certain size.  Defaults to FALSE.
#' @param bold_val a numeric scalar that indicates the value or greater that should be bolded. Defaults to .3. 
#' @param message if TRUE, messages are generated telling the user which group is above and below the diagonal. Defaults to TRUE.
#' @param ... optional arguments to be passed to pasterisk. 
#' @export

compare_rs <- function(x,
                       cols) {
  
  # check if x is a correlation matrix of length 14
  x_type <- typeof(x)
  x_len  <- length(x)
  
  if (x_type != "list") {
    stop("x is of type ", typeof(x), ". ",
         "x must be of type list. ",
         "Is x an object exported from psych::corr.test?")
  } else if (x_len != 14) {
    stop("x is of length ", x_len, ". ",
         "x must be of length 14. ",
         "Is x an object exported from psych::corr.test?")
  }
  
  # check other arguments
  # argument_check(cols, "x", "list")
  
  # extract r_mat and n
  x_r <- x$r
  n   <- x$n
  
  # if cols is provided, ensure they are correct
  if (!missing(cols)) {
    
    argument_check(cols, "cols", "character", TRUE, c(2, Inf))
    
    if (!all(cols %in% colnames(mat_c$r))) {
      stop("cols not found in data: ", 
           paste(cols[!cols %in% colnames(mat_c$r)], collapse = ", "))
    }
    
    # subset x to only include requested columns
    x_r <- x_r[, cols]
  } else {
    cols <- colnames(mat_c$r)
  }
  
  # create every combination of columns
  col_comps <- combn(cols, m = 2)
  
  col_comps <- split(col_comps, 
                     rep(seq_len(ncol(col_comps)), each = nrow(col_comps)))
  
  # compare columns for first row of x (to test)
  sapply(col_comps, 
        1, 
        FUN = function{})
  
  
  
}

mat_c  

t<-compare_rs(mat_c, cols = c("scale1_item1", "scale1_item2", "scale1_item3"))

# this is the code you 
lapply(t,
       FUN = function (x) mat_c$r[1, c(x)])


split(combn(c("scale1_item1", "scale1_item2", "scale1_item3"), m = 2), rep(1:ncol(combn(c("scale1_item1", "scale1_item2", "scale1_item3"), m = 2)), each = nrow(combn(c("scale1_item1", "scale1_item2", "scale1_item3"), m = 2))))


class(mat_b)

mat_b$class

argument_check(mat_c, "x", "list")
argument_check(mat_b, "x", "list")

  argument_check(adjust.p,   "adjust.p", "character", TRUE, 1)
  argument_check(spround,     "spround",   "logical", TRUE, 1)
  argument_check(pasterisk, "pasterisk",   "logical", TRUE, 1)
  argument_check(bold_script, "bold_script", "logical", len_check = TRUE)
  argument_check(bold_val, "bold_val", "numeric", len_check = TRUE)
  argument_check(message, "message", "logical", len_check = TRUE)





zo <- function(data, 
               cols, 
               split, 
               adjust.p    = "none", 
               spround     = TRUE,
               pasterisk   = TRUE,
               bold_script = FALSE,
               bold_val    = .30,
               message     = TRUE,
               ...) {
  
  # check arguments
  argument_check(data,           "data", "data.frame")
  argument_check(adjust.p,   "adjust.p", "character", TRUE, 1)
  argument_check(spround,     "spround",   "logical", TRUE, 1)
  argument_check(pasterisk, "pasterisk",   "logical", TRUE, 1)
  argument_check(bold_script, "bold_script", "logical", len_check = TRUE)
  argument_check(bold_val, "bold_val", "numeric", len_check = TRUE)
  argument_check(message, "message", "logical", len_check = TRUE)

  # if cols is missing, use all columns
  if (missing(cols)) {
    cols <- colnames(data)
    if (!missing(split)) {
      cols <- cols[cols != split]
    }
  # if cols is provided, ensure it is correct
  } else {
    argument_check(cols, "cols", "character", TRUE, c(2, Inf))
    if (!all(cols %in% colnames(data))) {
      stop("cols not found in data: ", 
           paste(cols[!cols %in% colnames(data)], collapse = ", "))
    }
  }
  
  # split data if splitting column provided
  if (!missing(split)) {
    argument_check(split, "split", "character")
    # ensure the length of split is equal to two
    if (lenique(data[, split]) != 2) {
      stop(paste0("zo is only able to distinguish between 2 groups. ",
                 "The length of split is ", lenique(data[, split][[1]]), "."))
    }

    data <- split(data, data[, split])
  }
  
  # run correlations
  if (!missing(split)) {
    cor_1  <- psych::corr.test(data[[1]][, cols], adjust = adjust.p)
    cor_2  <- psych::corr.test(data[[2]][, cols], adjust = adjust.p)
    cor_r <- mat_merge(cor_1$r, cor_2$r, "upper", "upper", diagonal = 1)
    cor_p <- mat_merge(cor_1$p, cor_2$p, "upper", "upper", diagonal = 0)
    out   <- data.frame(cbind(cor_r, cor_p))
  } else {
    cor_r <- mat_merge(psych::corr.test(data[, cols], adjust = adjust.p)$r,
                       psych::corr.test(data[, cols], adjust = adjust.p)$r,
                       "upper",
                       "upper")
    cor_p <- mat_merge(psych::corr.test(data[, cols], adjust = adjust.p)$p,
                       psych::corr.test(data[, cols], adjust = adjust.p)$p,
                       "upper",
                       "upper")
    out <- data.frame(cbind(cor_r, cor_p))
  }
  
  # add column and row names
  rownames(out) <- paste0(seq_along(cols), ". ", cols)
  colnames(out) <- c(paste0(cols, "_r"), paste0(cols, "_p"))
  
  # spround if TRUE
  if (spround) {
    out[, column_find("_r$", out)] <- sapply(out[, column_find("_r$", out)], 
                                        spround, 2, FALSE)
    if (!pasterisk) {
      out[, column_find("_p$", out)] <- sapply(out[, column_find("_p$", out)], 
                                        spround, 3, FALSE)
    }
  }
  
  # bold if TRUE
  if (bold_script) {
    out[, column_find("_r$", out)] <- sapply(out[, column_find("_r$", out)], 
      function(x) {
        x2 <- x
        x  <- as.numeric(x) 
        x2[abs(x) >= bold_val] <- bold_tex(x2[abs(x) >= bold_val])
        x2
      }
    )
  }
  
  # pasterisk if TRUE
  if (pasterisk) {
    out[, column_find("_p$", out)] <- sapply(out[, column_find("_p$", out)],
                                            pasterisk, ...)
    for (i in seq_along(cols)) {
      out[, i] <- paste0(out[, i], out[, i + length(cols)])
    }
    out <- column_find("_r$", out, "data.frame")
    colnames(out) <- paste0(seq_along(cols), ".")
  }
  
  # replace diagonal
  if (pasterisk) {
    diag(out) <- "-"
  }

  
  # message if data split and drop upper.tri if not
  if (!missing(split)) {
    if (message == TRUE) {
        message(names(data)[1], " is below the diagonal. ",
          names(data)[2], " is above the diagonal.")
    }
  } else {
    if (pasterisk) {
      out[upper.tri(out)] <- " "
    }
  }
  

  # return output
  out

}


