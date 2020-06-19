#' tidy_std
#'
#' Tidies lm and lmer model and includes the standardized coefficients, standard error, and confidence intervals..
#' @param model a lm or lmer model
#' @param conf.level the confidence level of the confidence intervals. Defaults to .95.
#' @export

tidy_std <- function(model, conf.level = .95) {
  
  # check arguments
  argument_check(model, "model", "list", len_check = FALSE)
  argument_check(conf.level, "conf.level", "numeric", len_check = TRUE)
  # tidy model
  out <- broom::tidy(model, conf.int = TRUE, conf.level = conf.level)
  
  # extract stanadrized paraemters
  estimate_std     <- effectsize::standardize_parameters(model)$Std_Coefficient
  
  # make estimate_std the same length as out
  len_dif          <- nrow(out) - length(estimate_std)
  estimate_std     <- append(estimate_std, rep(NA, len_dif))
  
  # combine tidied model with standardized parameters
  out <- cbind(out, estimate_std)
  
  # calculate SEs for estimate_std
  out$se_std <- out$estimate_std / out$statistic
  
  # calculate CI for estimate_std
  ci_factor <- qnorm(1 - (1 - conf.level) / 2)
  
  out$conf.low_std  <- out$estimate_std - (out$se_std * ci_factor)
  out$conf.high_std <- out$estimate_std + (out$se_std * ci_factor)
  
  # create df if it does not exist in the output
  if (!("df" %in% colnames(out))) {
    out$df <- summary(model)$df[2]
  }
  
  # rearrange columns
  term_col <- which(colnames(out) == "term")
  
  out <- cbind(out[, 1:term_col], out[, c("df",
                                          "estimate",
                                          "std.error",
                                          "conf.low",
                                          "conf.high",
                                          "estimate_std",
                                          "se_std",
                                          "conf.low_std",
                                          "conf.high_std",
                                          "statistic",
                                          "p.value")])
  
  # rename std.error
  colnames(out)           <- sub("std.error", "se", colnames(out))
  colnames(out)[term_col] <- "term"

  # retunr tidied model
  out
}
