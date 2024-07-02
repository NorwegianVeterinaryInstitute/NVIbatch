#' @title Save and report log for scripts
#' @description Reads the log file, identifies error messages and
#'     sends an email with the status for running the main script.
#'     The log file can be saved with the current date last in
#'     file name.
#' @details The function collects warnings and error messages from
#'     log file when a script has been run. This is dependant on that
#'     the script has been set up to produce the log file. There
#'     the name and path of the log file will have been given.
#'
#' The log file will be renamed so that the current date in the
#'     format "yyyymmdd" is included last in the file name before the
#'     file extension. This file should be permanently saved in an
#'     archive directory for example a subdirectory named "batchlog".
#'
#' If an email should report the status, an email is produced. The
#'     subject of the email indicates whether the script run without
#'     problems or if warnings or error messages were produced. The
#'     log file is attached the email. If there are warnings or error
#'     messages, these are written in the email text.
#'
#' It is possible include an short message first in the email text
#'     by giving it as input to the argument \code{include_text}. Such
#'     a message can give more information of the status of running the
#'     script. Such a message can be produced by the script and saved.
#'     Thereafter, the message can be fetched and be used as input to
#'     \code{include_text}.
#' @param log_file [\code{character(1)}]\cr
#'     File name of the log file.
#' @param log_path [\code{character(1)}]\cr
#'     Path for the log file.
#' @param save [\code{logical(1)}]\cr
#'     Whether the log file should be saved or not. Defaults to \code{TRUE}.
#' @param archive [\code{character(1)}]\cr
#'     The path to the directory to save the log file. Defaults to \code{NULL}.
#' @param email [\code{logical(1)}]\cr
#'     Whether an email with a report of the status in the log and the log file
#'     attached and the results file should be sent or not. Defaults to \code{TRUE}.
#' @param from [\code{character(1)}]\cr
#'     The email address of the sender. Defaults to \code{NULL}.
#' @param to [\code{character}]\cr
#'     The email address' of the recipients. Defaults to \code{NULL}.
#' @param include_text [\code{character(1)}]\cr
#'     Text to include in the first part of the body of the email. Defaults to
#'     \code{NULL}.
#' @param attach_object [\code{character}]\cr
#'     Full path and file name of object(s) to attach to the email. Defaults to
#'     \code{NULL}.
#' @param smtp_server [\code{character(1)}]\cr
#'     The email server that sends the emails. Defaults to \code{NULL}.
#' @param \dots Other arguments to be passed to \code{\link{gather_messages}} and
#'     \ifelse{html}{\code{\link[sendmailR:sendmail]{sendmailR::sendmail}}}{\code{sendmailR::sendmail}}.
#'
#' @return None. Saves the log after a script has been run
#'     and reports the error and warnings written in the log.
#'
#' @author Petter Hopp Petter.Hopp@@vetinst.no
#' @export
#'
save_log <- function(log_file,
                     log_path,
                     save = TRUE,
                     archive = NULL,
                     email = TRUE,
                     from = NULL,
                     to = NULL,
                     include_text = NULL,
                     attach_object = NULL,
                     smtp_server = NULL,
                     ...) {

  # PREPARE ARGUMENTS BEFORE CHECKING ----
  # Remove trailing backslash or slash before testing path
  log_path <- sub("\\\\{1,2}$|/{1,2}$", "", log_path)
  archive <- sub("\\\\{1,2}$|/{1,2}$", "", archive)

  # CAPTURE DOTS ----
  # Used below to ensure correct arguments for nested functions
  #   and check for deprecated arguments
  dots <- list(...)

  # CHECK FOR DEPRECATED ARGUMENTS ----
  if (!is.null(dots[[1]]) && "additional_info" %in% names(dots)) {
    if (is.null(include_text)) {
      include_text <- dots$additional_info
    }
    warning(paste("The argument 'additional_info' is deprecated.",
                  "Use 'include_text' instead.",
                  "The input to 'additional_info' has been transferred to 'include_text'."))
  }

  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Perform checks
  ## log_file & log_path
  checkmate::assert_string(log_file, min.chars = 1, add = checks)
  checkmate::assert_directory_exists(log_path, access = "r", add = checks)
  checkmate::assert_file_exists(file.path(log_path, log_file), access = "r", add = checks)
  ## save
  checkmate::assert_flag(save, add = checks)
  if (isTRUE(save)) {
    ## archive
    checkmate::assert_directory_exists(archive, access = "r", add = checks)
  }
  ## email
  checkmate::assert_flag(email, add = checks)
  ## to & from & additional info & smtp_server
  if (isTRUE(email)) {
    NVIcheckmate::assert_character(from,
                                   len = 1, min.chars = 5, max.chars = 256,
                                   pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", ignore.case = TRUE,
                                   comment = "The email address is not valid",
                                   add = checks)
    NVIcheckmate::assert_character(to,
                                   min.len = 1, min.chars = 5, max.chars = 256,
                                   pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", ignore.case = TRUE,
                                   comment = "One or more email address' are not valid",
                                   add = checks)
    ## include_text
    checkmate::assert_string(include_text, min.chars = 1, null.ok = TRUE, add = checks)
    ## attach_object
    checkmate::assert_character(attach_object, min.len = 1, min.chars = 1,
                                any.missing = FALSE, null.ok = TRUE, add = checks)
    if (!is.null(attach_object)) {
      for (object in attach_object) {
        checkmate::assert_file_exists(object, access = "r", add = checks)
      }
    }
    ## smtp_server
    checkmate::assert_string(smtp_server, min.chars = 5, max.chars = 256,
                             # pattern = "^[A-Z0-9.-]+\\.[A-Z]{2,}$", ignore.case = TRUE,
                             # comment = "The email server address is not valid",
                             add = checks)
  }

  # Report check-results
  checkmate::reportAssertions(checks)


  ## SAVE LOG FILE IN ARCHIVE ----
  if (isTRUE(save)) {
    # Copy log-file renamed with date, to track history
    log_ext <- ""
    if (grepl(".", log_file, fixed = TRUE)) {
      log_ext <- utils::tail(strsplit(x = log_file, split = ".", fixed = TRUE)[[1]], n = 1)
      log_file_crude <- sub(paste0(".", log_ext, "$"), "", log_file)
    }
    file.copy(from = file.path(log_path, log_file),
              to = file.path(archive, paste0(log_file_crude, "_", format(Sys.Date(), "%Y%m%d"), ".Rout")),
              copy.date = TRUE,
              overwrite = TRUE)
  }

  # COMPOSE EMAIL ----
  if (isTRUE(email)) {
    # Message text and attachment
    # https://stackoverflow.com/questions/2885660/how-to-send-email-with-attachment-from-r-in-windows
    # key part for attachments, put the body and the mime_part in a list for msg
    attachment_object <- sendmailR::mime_part(x = file.path(log_path, log_file),
                                              name = log_file)

    # Include error and warning messages if any
    dots1 <- intersect(setdiff(names(formals(gather_messages)), c("filename")), names(dots))
    # journal_rapp <- do.call(NVIdb::login, append(dots[dots1], list(dbservice = "PJS", dbinterface = "odbc")))
    messages <- do.call(gather_messages, append(dots[dots1], list(filename = file.path(log_path, log_file))))
    # messages <- gather_messages(filename = file.path(log_path, log_file), ...)
    if (length(messages) > 0) {
      subject <- paste("Error when running:", log_file_crude)
      body <- list(c("Error messages", messages), attachment_object)
    } else {
      subject <- paste("Status for running:", log_file_crude)
      body <- list(attachment_object)
    }

    # ATTACH MORE OBJECTS ----
    if (!is.null(attach_object)) {
      for (object in attach_object) {
        filename <- utils::tail(strsplit(normalizePath(object, winslash = "/"), split = "/")[[1]], 1)
        attachment_object <- sendmailR::mime_part(x = object, name = filename)
        body <- append(body, attachment_object)
      }
    }

    # INCLUDE TEXT ----
    if (!is.null(include_text)) {
      body <- append(body, include_text, after = 0)
    }

    # SEND EMAIL ----
    dots1 <- intersect(setdiff(names(formals(sendmailR::sendmail)),
                               c("from", "to", "subject", "msg", "control")),
                       names(dots))
    do.call(sendmailR::sendmail, append(dots[dots1],
                                        list(from = from,
                                             to = to,
                                             subject = subject,
                                             msg = body,
                                             control = list(smtpServer = smtp_server))))
    # sendmailR::sendmail(from = from,
    #                     to = to,
    #                     subject = subject,
    #                     msg = body,
    #                     control = list(smtpServer = smtp_server),
    #                     ...)
  }
}
