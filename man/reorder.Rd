% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reorder.R
\name{reorder}
\alias{reorder}
\title{reorder}
\usage{
reorder(data, key_column, sep = "\\\\|")
}
\arguments{
\item{data}{a data frame.}

\item{key_column}{a character string indicating the column containing the order strings.}

\item{sep}{a character string indicating the symbol that is used to split the column names. Defaults to "\\|" because that is what is used by Qualtrics.}
}
\description{
Reorders columns based on a string with separators. Defaults to splitting using "\\|", because that is what is used by Qualtrics.
}
