test_that("loop_map", {

  # With looplyr
  list(cars, mtcars) %m>% {
    mutate(x = 2)
  } -> out

  # Without looplyr
  cars_modified <- cars %>%
    mutate(x = 2)

  mtcars_modified <- mtcars %>%
    mutate(x = 2)

  expect_equal(cars_modified, out[[1]])
  expect_equal(mtcars_modified, out[[2]])
})

test_that("loop_future_map", {

  # With looplyr
  list(cars, mtcars) %f>% {
    loop_options(.progress = TRUE)
    mutate(x = 2)
  } -> out

  # Without looplyr
  cars_modified <- cars %>%
    mutate(x = 2)

  mtcars_modified <- mtcars %>%
    mutate(x = 2)

  expect_equal(cars_modified, out[[1]])
  expect_equal(mtcars_modified, out[[2]])
})

