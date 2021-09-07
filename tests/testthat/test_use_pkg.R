library(NVIbatch)
library(testthat)


test_that("Attach packages", {

  use_pkg("dplyr")
  expect_true("dplyr" %in% (.packages()))

  use_pkg(pkg = c("ISOweek", "snakecase"))
  expect_true("ISOweek" %in% (.packages()))
  expect_true("snakecase" %in% (.packages()))


})


