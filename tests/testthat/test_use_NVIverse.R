library(NVIbatch)
library(testthat)

test_that("Attach NVIverse packages", {

  use_NVIverse("NVIdb")
  expect_true("NVIdb" %in% (.packages()))

  use_NVIverse(pkg = c("NVIpretty", "OKplan"))
  expect_true("NVIpretty" %in% (.packages()))
  expect_true("OKplan" %in% (.packages()))

})


# test_that("Install NVIverse packages", {
# 
#   pkg <- "OKplan"
#   if (pkg %in% (.packages())) {
#     pkgname <- paste0("package:", pkg)
#     detach(pkgname, unload = TRUE, character.only = TRUE)
#     remove.packages(pkgs = pkg)
#   }
#   use_NVIverse(pkg = "OKplan")
#   expect_true("OKplan" %in% (.packages()))
# 
# })


test_that("Error messages for use_NVIverse", {

  expect_error(use_NVIverse(pkg = "plyr"),
             regexp = "Must comply to pattern '^NVI.*|^OK.*'",
             fixed = TRUE)

})
