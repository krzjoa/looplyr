% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loop-summarise.R
\name{loop_summarise}
\alias{loop_summarise}
\alias{loop_summarize}
\title{Summarise in loop}
\usage{
loop_summarise(.data, .x, ...)

loop_summarize(.data, .x, ...)
}
\arguments{
\item{.data}{a data.frame-like object}

\item{.x}{a vector the function is looping on}

\item{...}{Name-value pairs of summary functions.
The name will be the name of the variable in the result.
The value can be:
\itemize{
\item A vector of length 1, e.g. min(x), n(), or sum(is.na(y)).
\item A vector of length n, e.g. quantile().
\item A data frame, to add multiple columns from a single expression.
}}
}
\value{
An object of \code{tibble} class
It combines multiple summaries performed on the input data.frame.
}
\description{
Summarise in loop
}
\examples{
suppressMessages(library(dplyr))
suppressMessages(library(glue))
quantiles <- c(0.25, 0.50, 0.75)
iris \%>\%
  group_by(Species) \%>\%
  loop_summarise(
      quantiles,
      glue("Petal.Length.{.x}") := quantile(Petal.Length, .x),
      glue("Petal.Width.{.x}") := quantile(Petal.Width, .x)
  )
}
