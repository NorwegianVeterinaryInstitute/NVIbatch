library(NVIbatch)
library(testthat)
context("use_pkg")


test_that("If the packages are attached", {

  use_pkg("dplyr")
  expect_true("dplyr" %in% (.packages()))

  use_pkg(pkg = c("ISOweek", "snakecase"))
  expect_true("ISOweek" %in% (.packages()))
  expect_true("snakecase" %in% (.packages()))


})


