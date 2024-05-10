library(testthat)
library(checkmate)

# Assigns temporary dir to td
td <- tempdir()

test_that("save_log save main_script.Rout", {
  # Create log file to check
writeLines(text = c("Warning message:",
                    "Be aware of mistakes",
           "xxx",
           "aaa",
           "Ferdig batch script"),
           con = file.path(td, "main_script.Rout"))
save_log(log_file = "main_script.Rout",
         log_path = tempdir(),
         save = TRUE,
         archive = tempdir(),
         email = FALSE)
expect_file(x = file.path(td, paste0("main_script_", format(Sys.Date(), "%Y%m%d"), ".Rout")))
})


test_that("errors for save_log", {

  linewidth <- options("width")
  options(width = 80)

  expect_error(save_log(log_file = "no_file.Rout",
                        log_path = tempdir(),
                        archive = tempdir(),
                        email = FALSE),
               regexp = "File does not exist:")

  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = "tempdir",
                        archive = tempdir(),
                        email = FALSE),
               regexp = "Directory 'tempdir' does not exist.")
  
  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = tempdir(),
                        archive = "tempdir", 
                        email = FALSE),
               regexp = "Directory 'tempdir' does not exist.")
  
  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = tempdir(),
                        save = "TRUE",
                        archive = tempdir(), 
                        email = FALSE),
               regexp = "Must be of type 'logical flag'")
  
  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = tempdir(),
                        save = TRUE,
                        archive = tempdir(), 
                        email = "FALSE"),
               regexp = "Must be of type 'logical flag'")
  
  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = tempdir(),
                        save = TRUE,
                        archive = tempdir(), 
                        email = TRUE,
                        from = "@xx.no",
                        to = "xx@xx.no",
                        smtp_server = "mail_server"),
               regexp = "The email address is not")
  
  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = tempdir(),
                        save = TRUE,
                        archive = tempdir(), 
                        email = TRUE,
                        from = "xx@xx.no",
                        to = "@xx.no",
                        smtp_server = "mail_server"),
               regexp = "The email address is not")
  
  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = tempdir(),
                        save = TRUE,
                        archive = tempdir(), 
                        email = TRUE,
                        from = "xx@xx.no",
                        to = "xx@xx.no",
                        additional_info = FALSE,
                        smtp_server = "mail_server"),
               regexp = "'additional_info': Must be of type 'string'")
  
  expect_error(save_log(log_file = "main_script.Rout",
                        log_path = tempdir(),
                        save = TRUE,
                        archive = tempdir(), 
                        email = TRUE,
                        from = "xx@xx.no",
                        to = "xx@xx.no",
                        additional_info = NULL,
                        smtp_server = NULL),
               regexp = "'smtp_server': Must be of type 'string'")
  
 options(width = unlist(linewidth))
})

