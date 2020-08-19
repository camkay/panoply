#' dark
#'
#' A function for returning a vector of aversive personality trait names (e.g., the Dark Triad or Dark Tetrad traits).
#' 
#' @param constellation a character scalar specifying whether to return the names of the Dark Triad traits or the names of the Dark Tetrad traits. Defaults to "Triad".
#' @param shorten a logical scalar indicating whether to shorten the trait names. Defaults to `FALSE`.
#' @param shorten_length a numeric scaler indicating the number of letters to return (e.g., `4` would return "Mach" instead of "Machiavellianism"). Defaults to `4`.
#' @param format a character scalar indicating whether to italicize or bold the string. Defaults to "none.
#' @param ... additional arguments are assed to `text_format`.
#' @export

dark <- function(constellation  = "triad", 
                 shorten        = FALSE, 
                 shorten_length = 4, 
                 format         = "none",
                 ...) {
  
  # check arguments
  argument_check(constellation, "constellation", "character", len_check = TRUE)
  argument_check(shorten, "shorten", "logical", len_check = TRUE)
  argument_check(shorten_length, "shorten_length", "numeric", len_check = TRUE)
  argument_check(format, "format", "character", len_check = TRUE)
  
  # check constellation choices
  if (constellation != "triad" &
      constellation != "tetrad") {
    warning("constellation must be \"triad\" or \"tetrad\". \"",
            constellation,
            "\" was provided. \"triad\" used instead.")
    constellation <- "triad"
  }
  
  # load trait names
  traits <- c("Machiavellianism",
              "Narcissism",
              "Psychopathy")
  
  if (constellation == "tetrad") {
    traits <- c(traits,
               "Sadism")
  }
  
  # if shorten is true, shorten according to shorten length
  if (shorten) {
    traits <- substr(traits, 1, shorten_length)
  }
  
  # format if format does not equal "none"
  if (format != "none") {
    traits <- text_format(traits, format = format, ...)
  }
  
  return(traits)
}

#' @rdname dark
#' @export

dark_triad <- function(...) {
  dark(constellation = "triad", ...)
}

#' @rdname dark
#' @export

dark_tetrad <- function(...) {
  dark(constellation = "tetrad", ...)
}
