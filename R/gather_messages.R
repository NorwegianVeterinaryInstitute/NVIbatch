#' @title Gather error and warning messages from the Rout-file
#' @description Reads the Rout-file generated when running R in batch mode.
#'     Identifies lines with error and warning messages and report these. It is
#'     possible to predefine allowed warnings that shall not be reported.
#' @details \code{remove_allowed} is used to remove warnings that is allowed.
#'     Warnings that include the specified text string(s) will be removed. As
#'     default warnings including the string "was built under R version" will be
#'     removed. These warnings indicate that the package was built for a later
#'     R-version than the version used to run the R-script.
#' \code{remove_after} is used to remove all messages after a predefined
#'     tag. The tag can be set using print() in the R-script producing the
#'     Rout-file. This may be useful as error messages will be produced at the
#'     end of Rout-file if the user don't have writing access at working
#'     directory from which R-script is run.
#'
#' @param filename [\code{character(1)}]\cr
#'     The name of the Rout-file.
#' @param remove_allowed [\code{character}]\cr
#'     Warning text that is allowed, case is ignored. Defaults to
#'     c("was built under R version").
#' @param remove_after [\code{character}]\cr
#'     Removes all messages after a predefined tag, case is ignored.
#'     See details. Defaults to "Ferdig Batch".
#'
#' @return Vector with error and warning messages that was written in the log.
#'
#' @author Petter Hopp Petter.Hopp@@vetinst.no
#' @export
#' @examples
#' \dontrun{
#' # Gather messages from the log file "script.Rout".
#' library(NVIbatch)
#' messages <- gather_messages(filename = file.path(getwd(), "script.Rout"),
#'                               remove_after = "Finished script")
#' }
gather_messages <- function(filename,
                            remove_allowed = c("was built under R version"),
                            remove_after = "Ferdig Batch") {

  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Perform checks
  checkmate::assert_file_exists(filename, access = "r")

  checkmate::assert_character(remove_allowed, min.chars = 1, any.missing = FALSE, null.ok = TRUE, add = checks)

  checkmate::assert_character(remove_after, len = 1, min.chars = 1, any.missing = FALSE, null.ok = TRUE, add = checks)

  # Report check-results
  checkmate::reportAssertions(checks)


  # RUNNING SCRIPT ----
  # Reads the Rout-file (logfile)
  logfile <- readLines(con = filename)


  # Identifies lines with error messages
  # Collects the line with error and the two next lines
  error_lines <- grep("error", x = logfile, ignore.case = TRUE)
  error_lines <- c(error_lines, error_lines + 1, error_lines + 2)

  # Collects the line with fatal and the next line
  # Fatal is used when uploading to shiny server fails
  fatal_lines <- grep("fatal", x = logfile, ignore.case = TRUE)
  fatal_lines <- c(fatal_lines, fatal_lines + 1)

  # Identifies lines with warning messages
  # Collects the line with warning and the next line
  warning_lines <- grep("warning", x = logfile, ignore.case = TRUE)
  warning_lines <- c(warning_lines, warning_lines + 1)

  # Identifies lines summarising warning messages
  # Collects the line with summary of warnings
  summary_warning_lines <- grep("use warnings\\() to see them", x = logfile, ignore.case = TRUE)


  # Combines error and warning messages
  message_lines <- unique(c(error_lines, fatal_lines, warning_lines, summary_warning_lines))
  message_lines <- message_lines[order(message_lines)]

  # Identifies lines with allowed warnings
  if (!is.null(remove_allowed) && all(trimws(remove_allowed) != "")) {
    for (i in 1:length(remove_allowed)) {
      allowed <- grep(pattern = remove_allowed[i], x = logfile, ignore.case = TRUE)
      if (i == 1) {
        allowed_lines <- allowed
      } else {
        allowed_lines <- c(allowed_lines, allowed)
      }
    }
    # Allows the line with allowed warning and the previous line
    allowed_lines <- c(allowed_lines, allowed_lines - 1)
  }
  if (!exists("allowed_lines")) {allowed_lines <- 1}

  # Removes messages after a defined tag that can be set with print()
  if (!is.null(remove_after) && trimws(remove_after) != "") {
    finished <- grep(pattern = remove_after, x = logfile, ignore.case = TRUE)
  }
  if (exists("finished")) {
    if (length(finished) > 0) {
      finished <- min(finished)
      allowed_lines <- c(allowed_lines, finished:length(logfile))
    }
  }
  # Removes allowed_lines from the gathered errors and warnings
  message_lines <- message_lines[which(!message_lines %in% allowed_lines)]

  # Make a data frame with line numbers and error and warning messages
  messages <- as.data.frame(logfile[message_lines], StringAsFactors = FALSE)
  messages <- paste(message_lines, messages[, 1])

  return(messages)
}
