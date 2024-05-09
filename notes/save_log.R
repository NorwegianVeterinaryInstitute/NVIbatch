#' @title Save and report log for scripts
#' @description Reads the log file, identifies error messages and
#'     sends an email with the status for running the main script.
#'     The log file can be saved with the current date last in 
#'     file name. 
#' @author Petter Hopp Petter.Hopp@@vetinst.no
#' 

# SET UP R ENVIRONMENT ----
# Attach R packages ----
library(NVIbatch)
NVIbatch::use_NVIverse(pkg = c("NVIdb"))
use_pkg(pkg = c("sendmailR"))

# Global variables ----
## paths and file names
repository <- "AnimalPopulation"
domain <- file.path(set_dir_NVI("EksterneDatakilder", slash = FALSE), "Dyrepopulasjon")
main_script <- "main_create_animal_populations"  # navnet på scriptet som det skal lage logg for
main_script_Rout <- paste0(main_script, ".Rout")

## The path to the R-scripts
script_path <- file.path(domain, "GitHub", repository)

# Specific input to functions in script 
# email addresses
from_email <- "<epi@vetinst.no>"
to_email <- c("<petter.hopp@vetinst.no>", "<johan.akerstedt@vetinst.no>")
to_email <- c("<petter.hopp@vetinst.no>")

save_log <- function(log_file = main_script_Rout,
                     log_path = script_path,
                     save = TRUE,
                     archive = script_path, #file.path(domain, "batchlog"),
                     email = TRUE,
                     from = from_email,
                     to = to_email,
                     additional_info = NULL,
                     smtp_server = "webmail.vetinst.no",
                     ...) {
  
  ## ARGUMENT TESTING
  
  ## SAVE LOG FILE IN ARCHIVE ----
  if (isTRUE(save)) {
    # Copy log-file renamed with date, to track history
    log_ext <- ""
    if (grepl(".", log_file, fixed = TRUE)) {
      log_ext <- tail(unlist(strsplit(x = log_file, split = ".", fixed = TRUE)), n = 1)
      log_file_crude <- sub(paste0(".", log_ext, "$"), "", log_file)
    }
    file.copy(from = file.path(log_dir, log_file), 
              to = file.path(archive_dir, paste0(log_file_crude, "_", format(Sys.Date(), "%Y%m%d"), ".Rout")),
              copy.date = TRUE)
  }
  
  
  # COMPOSE EMAIL ----
  if (isTRUE(email)) {
    # Message text and attachment
    # https://stackoverflow.com/questions/2885660/how-to-send-email-with-attachment-from-r-in-windows
    # key part for attachments, put the body and the mime_part in a list for msg
    attachment_object <- mime_part(x = file.path(log_dir, log_file), 
                                   name = log_file)
    
    # Include error and warning messages if any
    messages <- gather_messages(filename = file.path(log_dir, log_file))
    if (length(messages)>0) {
      subject <- paste("Error when running:", log_file_crude)
      body <- list(c("Error messages", messages), attachment_object)
    } else {
      subject <- paste("Status for running:", log_file_crude)
      body <- list(attachment_object)
    }
    
    # INCLUDE ADDITIONAL INFORMATION ----
    if (!is.null(additional_info)) {
      append(body, additional_info, after = 0)
    }
    
    # SEND EMAIL ----
    sendmail(from = from,
             to = to,
             subject = subject,
             msg = body, 
             control = list(smtpServer = smtp_server))
  }
}
