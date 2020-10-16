#' @name loop-operator
#'
#' Map operator
#'
#' @param lhs a list; typically a list of data.frame-like objects handled with
#' standard dplyr methods
#' @param rhs a pipeline in curly brackets
#' @return list of processed data.frame-like objects
#'
#' @description
#' Can be considered as a syntactic sugar for a solution
#' combining `purrr::map` and `dplyr`/`magrittr` pipeline.
#'
#' Optionaly, you can specify additional arguments adding
#' a `loop_options` call as a first expression in
#' the curly brackets. It should not be followed by
#' `%>%`, because it will not work. For now now,
#' `loop_options` is only used to pass arguments for
#' `furrr::future_map`, like:
#'
#' loop_options(.progress = TRUE)
#'
#' @importFrom stringi stri_match
#' @examples
#' library(dplyr)
#' library(looplyr)
#'
#' # Simple map
#' two_dfs <- list(cars, mtcars) %m>% {
#'   mutate(idx = 1:n())
#' }
#'
#' # Parallel future_map
#' two_dfs <- list(cars, mtcars) %f>% {
#'   loop_options(.progress = TRUE)
#'   mutate(idx = 1:n())
#' }
#'
NULL

.abstract_loop_operator <- function(lhs, rhs, envir){
  # Check data
  if (!is.list(lhs))
    stop("LHS expression is not a list!")

  .loop_ops <- NULL

  # Create a pipeline function
  .pipe_expr <- deparse(rhs)

  # Check if loop_options are passed
  # pattern <- "loop_options\\(.*?\\)"
  # if (grep(pattern, pipe_as_string)) {
  #   .loop_ops_str <- stri_match(
  #     pipe_as_string, regex = pattern
  #   )[1, 1]
  #   .loop_ops_expr <- parse(text = .loop_ops_str)
  #   .loop_ops <- eval(.loop_ops_expr, envir = envir)
  #   pipe_as_string <- sub(
  #     pattern, ".", pipe_as_string
  #   )
  if (length(pipe_as_string) == 4) {
    .loop_ops_str  <- .pipe_expr[[2]]
    pipe_as_string <- .pipe_expr[[3]]
    .loop_ops_expr <- parse(text = .loop_ops_str)
    .loop_ops      <- eval(.loop_ops_expr, envir = envir)
   }

  pipe_as_string <- paste0(". %>% ",  pipe_as_string[[2]])

  parsed_pipe    <- parse(text = pipe_as_string)
  .pipe <- eval(parsed_pipe, envir = envir)
  list(.pipe, .loop_ops)
}

#' @rdname loop-operator
#' @importFrom purrr map
#' @export
`%m>%` <- function(lhs, rhs){
  .pipe_and_ops <- .abstract_loop_operator(
    lhs, substitute(rhs),
    envir = parent.frame()
  )
  .pipe <- .pipe_and_ops[[1]]
  # Applying map
  map(lhs, .pipe)
}


#' @rdname loop-operator
#' @importFrom furrr future_map
#' @export
`%f>%` <- function(lhs, rhs){
  .pipe_and_ops <- .abstract_loop_operator(
    lhs, substitute(rhs),
    envir = parent.frame()
  )
  .pipe <- .pipe_and_ops[[1]]
  .ops  <- .pipe_and_ops[[2]]

  .args <- c(
    list(.x = lhs, .f = .pipe),
    .ops
  )

  # To do not load future, which loads own operators
  do.call(furrr::future_map, .args)
}

#' @rdname loop-operator
loop_options <- function(...){
  structure(
    .Data = list(...),
    class = c("loop_options", "list")
  )
}
