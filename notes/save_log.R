#' @title Report log after running main scripts
#' @description Reads the log file, identifies error messages and
#'     sends an email with the status for running the main script.
#' @author Johan Åkerstedt Johan.Akerstedt@@vetinst.no
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
# Current script file (location path) and whether it runs on the server (TRUE/FALSE)
# After running this everything can be sourced from additional R scripts
# if (getwd() == "C:/WINDOWS/system32") {
script_path <- file.path(domain, "GitHub", repository)
#   # NVIoutbreak <- paste0(set_dir_NVI("NVIverse"), "/NVIoutbreak/source/")
#   # running_on_server <- TRUE
# } else {  
#   script_path <- getwd()
#   # NVIoutbreak <- paste0(dirname(getwd()),"/NVIoutbreak/source/")
#   # running_on_server <- FALSE
# }

# Today's date in the format yyyymmdd for use in file names
today <- format(Sys.Date(),"%Y%m%d")

# Specific input to functions in script 
# email addresses
from <- "<epi@vetinst.no>"
to <- c("<petter.hopp@vetinst.no>", "<johan.akerstedt@vetinst.no>")

# SAVE LOG FILE ----
# Copy log-file renamed with date, to track history
file.copy(from = file.path(script_path, main_script_Rout), 
          to = file.path(domain, "Batchlog", paste0(main_script, "_", today, ".Rout")))

# COMPOSE EMAIL ----
# Message text and attachment
# https://stackoverflow.com/questions/2885660/how-to-send-email-with-attachment-from-r-in-windows
# key part for attachments, put the body and the mime_part in a list for msg
attachment_object <- mime_part(x = file.path(script_path, main_script_Rout), 
                               name = main_script_Rout)

# Include error and warning messages if any
messages <- gather_messages(filename = file.path(script_path, main_script_Rout))
if (length(messages)>0) {
  subject <- paste("Error when running:", main_script)
  body <- list(c("Error messages", messages), attachment_object)
} else {
  subject <- paste("Status for running:", main_script)
  body <- list(attachment_object)
}

# SEND EMAIL ----
sendmail(from = from,
         to = to,
         subject = subject,
         msg = body, 
         control = list(smtpServer="webmail.vetinst.no"))
