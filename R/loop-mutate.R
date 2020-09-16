#' @name loop_mutate
#' @title `mutate` in loop
#' @param .data a data.frame
#' @param idx idx vector
#' @param ... expressions
#' @importFrom rlang call_args
#' @examples
#' suppressMessages(library(dplyr))
#' # Looping trough exponents
#' cars %>%
#'   loop_mutate(2:4, paste0("speed.", .idx) := speed ** .idx) %>%
#'   head(5)
#' # Working on groups
#' @export
loop_mutate <- function(.data, idx, ...){

  # TODO:
  # * optimize?
  # * processing order
  .calls <- .extract_calls(...)

  for (.idx in idx) {
    for (ops in .calls) {
      call.args <- rlang::call_args(ops)
      ops.lhs <- eval(call.args[[1]])
      ops.rhs <- call.args[[2]]
      string.expr <- sprintf("mutate(.data, !!ops.lhs := %s)", deparse(substitute(ops.rhs)))
      .data <- eval(parse(text = string.expr))
      # .data <- mutate(.data, !!ops.1 := rlang::expr(deparse(substitute(ops.2))))
    }
  }
  return(.data)
}

