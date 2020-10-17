#' Summarise in loop
#'
#' @param .data a data.frame-like object
#' @param .x a vector the function is looping on
#' @param ... Name-value pairs of summary functions.
#' The name will be the name of the variable in the result.
#' The value can be:
#'
#' * A vector of length 1, e.g. min(x), n(), or sum(is.na(y)).
#' * A vector of length n, e.g. quantile().
#' * A data frame, to add multiple columns from a single expression.
#' @return An object of `tibble` class
#' It combines multiple summaries performed on the input data.frame.
#' @importFrom purrr reduce
#' @examples
#' suppressMessages(library(dplyr))
#' suppressMessages(library(glue))
#' quantiles <- c(0.25, 0.50, 0.75)
#' iris %>%
#'   group_by(Species) %>%
#'   loop_summarise(
#'       quantiles,
#'       glue("Petal.Length.{.x}") := quantile(Petal.Length, .x),
#'       glue("Petal.Width.{.x}") := quantile(Petal.Width, .x)
#'   )
#' @export
loop_summarise <- function(.data, .x, ...){
  # TODO:
  # * optimize?
  # * processing order
  .calls      <- .extract_calls(...)
  .group_vars <- group_vars(.data)
  .x_seq      <- .x
  l <- list()

  for (.x in .x_seq) {
    for (ops in .calls) {
      call_arguments <- rlang::call_args(ops)
      ops_lhs        <- eval(call_arguments[[1]])
      ops_rhs        <- call_arguments[[2]]
      string_expr    <- sprintf("summarise(.data, !!ops_lhs := %s)",
                              deparse(substitute(ops_rhs)))
      # Suppres `summarise()` ungrouping output (override with `.groups` argument)
      l[[ops_lhs]] <- suppressMessages(eval(parse(text = string_expr)))
    }
  }
  .data <- reduce(l, ~ left_join(.x, .y, by = .group_vars))
  return(.data)
}

#' @rdname loop_summarise
#' @export
loop_summarize <- loop_summarise
