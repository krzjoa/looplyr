#' summarise in loop
#' @param .data a data.frame
#' @param idx idx vector
#' @param ... expressions
#' @importFrom purrr reduce
#' @examples
#' suppressMessages(library(dplyr))
#' library(glue)
#' quantiles <- c(0.25, 0.50, 0.75)
#' # Looping trough exponents
#' iris %>%
#'   group_by(Species) %>%
#'   loop_summarise(quantiles, glue("Petal.Length.{.idx}") := quantile(Petal.Length, .idx)) %>%
#'   head(5)
#' # Working on groups
#' @export
loop_summarise <- function(.data, idx, ...){
  # TODO:
  # * optimize?
  # * processing order
  .calls      <- .extract_calls(...)
  .group_vars <- group_vars(.data)
  l <- list()

  for (.idx in idx) {
    for (ops in .calls) {
      call_arguments <- rlang::call_args(ops)
      ops_lhs      <- eval(call_arguments[[1]])
      ops_rhs      <- call_arguments[[2]]
      string_expr  <- sprintf("summarise(.data, !!ops_lhs := %s)",
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
