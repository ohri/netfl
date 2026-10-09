test_that("season and week validation rejects invalid input", {
  expect_invisible(netfl:::validate_season(2024))
  expect_invisible(netfl:::validate_week(1))
  expect_invisible(netfl:::validate_week(NULL, allow_null = TRUE))
  expect_error(netfl:::validate_season(2023.5))
  expect_error(netfl:::validate_week(0))
  expect_error(netfl:::validate_week(23))
})

test_that("skinny PBP selection has a stable schema", {
  result <- netfl:::select_skinny_pbp(data.frame(game_id = "x", play_id = 1))

  expect_named(result, netfl:::skinny_pbp_columns())
  expect_equal(nrow(result), 1)
  expect_equal(result$game_id, "x")
})

test_that("SQL literals are safe and preserve missing values", {
  expect_equal(netfl:::sql_literal(c("O'Brien", NA)), c("'O''Brien'", "NULL"))
  expect_equal(netfl:::sql_literal(c(1, 2.5)), c("1", "2.5"))
})
