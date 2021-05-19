#' @title Gather error and warning messages from the Rout-file
#' @description Reads the Rout-file generated when running R in batch mode.
#'     Identifies lines with error and warning messages and report these. It is
#'     possible to predefine allowed warnings that shall not be reported.
#' @details \code{remove_allowed} is used to remove warnings that is allowed.
#'     Warnings that include the specified text string(s) will be removed. As
#'     default warnings including the string "was built under R version" will be
#'     removed. These warnings indicate that the package was built for a later
#'     R-version than the version used to run the R-script.
#'
#'     \code{remove_after} is used to remove all messages after a predefined
#'     tag. The tag can be set using print() in the R-script producing the
#'     Rout-file. This may be useful as error messages will be produced at the
#'     end of Rout-file if the user don't have writing access at working
#'     directory from which R-script is run.
#'
#' @param filename The name of the Rout-file.
#' @param remove_allowed character vector.
#' @param remove_after character string. Removes all messages after a predefined
#'     tag, see details. The tag can be set using print() in the R-script producing the
#'     Rout-file. This may be useful as error messages will be produced at the
#'     end of Rout-file if the user don't have writing access at the server
#'     running the R-script.
#' @export
#'

gather_messages <- function(filename,
                            remove_allowed = c("was built under R version"),
                            remove_after = "Ferdig Batch") {
  #Reads the Rout-file (logfile)
  logfile <- readLines(con = filename)


  # Identifies lines with error messages
  # Collects the line with error and the two next lines
  error_lines<-grep("Error",logfile)
  error_lines<-c(error_lines, error_lines+1, error_lines+2)

  # Identifies lines with warning messages
  # Collects the line with warning and the next line
  warning_lines<-grep("Warning",logfile)
  warning_lines<-c(warning_lines,warning_lines+1)

  # Combines error and warning messages
  message_lines<-unique(c(error_lines,warning_lines))
  message_lines<-message_lines[order(message_lines)]

  # Identifies lines with allowed warnings
  for (i in 1:length(remove_allowed)) {
    allowed <- grep(remove_allowed[i], logfile)
    if (i == 1) {
      allowed_lines <- allowed
    } else {
      allowed_lines <- c(allowed_lines, allowed)
    }
  }
  # Allows the line with allowed warning and the previous line
  allowed_lines <- c(allowed_lines, allowed_lines - 1)

  # Removes messages after a defined tag that can be set with print()
  finished <- min(grep(remove_after, logfile))

  if (length(finished) > 0) {
    allowed_lines <- c(allowed_lines, finished:length(logfile))
  }

  # Removes allowed_lines from the gathered errors and warnings
  message_lines <- message_lines[which(!message_lines %in% allowed_lines)]

  # Make a data frame with line numbers and error and warning messages
  messages <- as.data.frame(logfile[message_lines], StringAsFactors = FALSE)
  messages <- paste(message_lines, messages[,1])

  return(messages)


}
