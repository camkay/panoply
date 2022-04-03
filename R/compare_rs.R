#' compare_rs
#'
#' Compares two correlations. Currently, `compare_rs()` only supports correlations that have one variable in common and that were calculated in the same sample.
#' @param cor_mat a correlation matrix object created using the `corr.test()` function from the `{psych}` package. 
#' @param predictors a vector of strings indicating the names of the predictors.
#' @param outcome a string indicating the name of the outcome variable.
#' @param test a string indicating the type of test to use to compare the correlations. Defaults to hittner2003.
#' @param adjust.p a string indicating what type of correction for multiple comparisons should be used. Defaults to "none."
#' @param threshold a numeric scalar indicating the p-value that should be used to determine if two correlations are signficantly different from eachother. Defaults to .05. 
#' @export

compare_rs <- function(cor_mat,
                       predictors,
                       outcome,
                       test      = "hittner2003",
                       adjust.p  = "none",
                       threshold = .05) {
  
  # check if cor_mat is a correlation matrix of length 14
  cor_mat_type <- typeof(cor_mat)
  cor_mat_len  <- length(cor_mat)
  
  if (cor_mat_type != "list") {
    stop("cor_mat is of type ", typeof(cor_mat), ". ",
         "cor_mat must be of type list. ",
         "Is cor_mat an object exported from psych::corr.test?")
  } else if (cor_mat_len != 14) {
    stop("cor_mat is of length ", cor_mat_len, ". ",
         "cor_mat must be of length 14. ",
         "Is cor_mat an object exported from psych::corr.test?")
  }
  
  # check other arguments
  argument_check(predictors, "predictors", "character", TRUE, c(2, Inf))
  argument_check(outcome,       "outcome", "character", TRUE, 1)
  argument_check(test,             "test", "character", TRUE, 1)
  argument_check(adjust.p,     "adjust.p", "character", TRUE, 1)
  argument_check(threshold,   "threshold",   "numeric", TRUE, 1)
  
  test <- choice_check(test, "test", c("hittner2003",
                                       "pearson1898",
                                       "hotelling1940",
                                       "hendrickson1970",
                                       "williams1959",
                                       "olkin1967",
                                       "dunn1969",
                                       "steiger1980",
                                       "meng1992",
                                       "zou2007"))
  
  # extract r_mat and n
  cor_mat_r <- cor_mat$r
  cor_mat_n <- cor_mat$n
  
  # check if predictors are found within cor_mat
  if (!all(predictors %in% colnames(cor_mat_r))) {
    stop("predictors not found in data: ",
         paste(predictors[!predictors %in% colnames(cor_mat_r)], 
               collapse = ", "))
  }

  # check if outcome is found within cor_mat
  if (!outcome %in% colnames(cor_mat_r)) {
    stop("outcome not found in data: ",
         outcome)
  }
  
  # create every combination of columns
  col_comps <- combn(predictors, m = 2)

  col_comps <- split(col_comps,
                     rep(seq_len(ncol(col_comps)), each = nrow(col_comps)))
  
  # compare correlations
  comparisons <- lapply(col_comps,
                        FUN = function (col_comp) {
    jk <- cor_mat_r[outcome, col_comp[1]]
    jh <- cor_mat_r[outcome, col_comp[2]]
    kh <- cor_mat_r[col_comp[1], col_comp[2]]

    results <- cocor::cocor.dep.groups.overlap(r.jk         = jk,
                                               r.jh         = jh,
                                               r.kh         = kh,
                                               n            = cor_mat_n,
                                               return.htest = TRUE)

    results <- data.frame(lhs       = col_comp[1],
                          rhs       = col_comp[2],
                          n         = cor_mat_n,
                          r.jk      = jk,
                          r.jh      = jh,
                          r.kh      = kh,
                          diff      = jk - jh,
                          statistic = results[[test]]$statistic,
                          p         = results[[test]]$p.value)
    
    results
    })
  
  # flatten comparisons
  comparisons <- as.data.frame(do.call(rbind, comparisons))
  
  # adjust p.values
  comparisons$p <- p.adjust(comparisons$p, method = adjust.p)
  
  # add cld
  ps        <- comparisons$p
  names(ps) <- paste0(comparisons$lhs, "-", comparisons$rhs)
  cld       <- multcompView::multcompLetters(ps, threshold = threshold)$Letters
  
  out <- list(comparisons = comparisons,
              cld         = cld)
  
  # return out
  return(out) 
}