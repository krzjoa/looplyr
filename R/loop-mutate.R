#' Mutate in loop
#'
#' @param .data a data.frame-like object
#' @param .x a vector the function is looping on
#' @param ... Name-value pairs. The name gives the name of the column in the output.
#' The value can be:
#'
#' * A vector of length 1, which will be recycled to the correct length.
#' * A vector the same length as the current group (or the whole data frame if ungrouped).
#' * NULL, to remove the column.
#' * A data frame or tibble, to create multiple columns in the output.
#'
#' @importFrom rlang call_args
#' @examples
#' suppressMessages(library(dplyr))
#' # Looping trough exponents
#' cars %>%
#'   loop_mutate(2:4, paste0("speed.", .x) := speed ** .x) %>%
#'   head(5)
#' @export
loop_mutate <- function(.data, .x, ...){
  # TODO:
  # * optimize?
  # * processing order
  .calls <- .extract_calls(...)
  .x_seq <- .x
  for (.x in .x_seq) {
    for (ops in .calls) {
      .call_args <- rlang::call_args(ops)
      .ops_lhs <- eval(.call_args[[1]])
      .ops_rhs <- .call_args[[2]]
      .string_expr <- sprintf(
        "mutate(.data, !!.ops_lhs := %s)",
         deparse(substitute(.ops_rhs))
      )
      .data <- eval(parse(text = .string_expr))
    }
  }
  return(.data)
}
