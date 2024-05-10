library(testthat)

# Assigns temporary dir to td
td <- tempdir()

test_that("gather messages in main_script.Rout", {
  # Create log file to check
writeLines(text = c("Warning message:",
                    "Be aware of mistakes",
           "xxx",
           "aaa",
           "Ferdig batch script"),
           con = file.path(td, "main_script.Rout"))
messages <- gather_messages(filename = file.path(td, "main_script.Rout"))
expect_equal(messages,
             c("1 Warning message:","2 Be aware of mistakes"))

  # Create log file to check
writeLines(text = c("error:",
                    "Be aware of mistakes",
                    "xxx",
           "aaa",
           "Ferdig batch script"),
           con = file.path(td, "main_script.Rout"))
messages <- gather_messages(filename = file.path(td, "main_script.Rout"))
expect_equal(messages,
             c("1 error:","2 Be aware of mistakes", "3 xxx"))

  # Create log file to check
writeLines(text = c("FATAL:",
                    "Be aware of mistakes",
                    "xxx",
           "aaa",
           "Ferdig batch script"),
           con = file.path(td, "main_script.Rout"))
messages <- gather_messages(filename = file.path(td, "main_script.Rout"))
expect_equal(messages,
             c("1 FATAL:","2 Be aware of mistakes"))

})

test_that("remove cleared warnings from gather messages in main_script.Rout", {
  # Create log file to check
  writeLines(text = c("Warning message:",
                      "Be aware of mistakes",
                      "xxx",
                      "Warning message:",
                      "package ‘testthat’ was built under R version 4.3.2",
                      "aaa",
                      "Ferdig batch script"),
             con = file.path(td, "main_script.Rout"))
  messages <- gather_messages(filename = file.path(td, "main_script.Rout"))
  expect_equal(messages,
               c("1 Warning message:","2 Be aware of mistakes"))
  
  messages <- gather_messages(filename = file.path(td, "main_script.Rout"),
                              remove_allowed = c("was built under R version"))
  expect_equal(messages,
               c("1 Warning message:","2 Be aware of mistakes"))
  
  messages <- gather_messages(filename = file.path(td, "main_script.Rout"),
                              remove_allowed = c("was built under R version 3.1.1"))
  expect_equal(messages,
               c("1 Warning message:", "2 Be aware of mistakes",
                 "4 Warning message:", "5 package ‘testthat’ was built under R version 4.3.2"))
  
})

test_that("remove warnings late in main_script.Rout", {
  # Create log file to check
  writeLines(text = c("Warning message:",
                      "Be aware of mistakes",
                      "xxx",
                      "aaa",
                      "Ferdig Batch script",
                      "Warning message:",
                      "Late mistake"),
             con = file.path(td, "main_script.Rout"))
  messages <- gather_messages(filename = file.path(td, "main_script.Rout"))
  expect_equal(messages,
               c("1 Warning message:","2 Be aware of mistakes"))
  
  messages <- gather_messages(filename = file.path(td, "main_script.Rout"),
                              remove_after = c("Ferdig Batch"))
  expect_equal(messages,
               c("1 Warning message:","2 Be aware of mistakes"))
  
  messages <- gather_messages(filename = file.path(td, "main_script.Rout"),
                              remove_after = c("Finished Batch"))
   expect_equal(messages,
               c("1 Warning message:", "2 Be aware of mistakes",
                 "6 Warning message:", "7 Late mistake"))
  
})


test_that("errors for gather_messages", {

  linewidth <- options("width")
  options(width = 80)

  expect_error(gather_messages(filename = "no_file.Rout"),
               regexp = "File does not exist: 'no_file.Rout'")

  expect_error(gather_messages(filename = file.path(td, "main_script.Rout"),
                               remove_allowed = NA),
               regexp = "Variable 'remove_allowed': Contains missing values")
  
  expect_error(gather_messages(filename = file.path(td, "main_script.Rout"),
                               remove_after = NA),
               regexp = "Variable 'remove_after': Contains missing values")
  
  expect_error(gather_messages(filename = file.path(td, "main_script.Rout"),
                               remove_after = c("x", "y", "z")),
               regexp = "Variable 'remove_after': Must have length 1, but has length 3")
  
 options(width = unlist(linewidth))
})

