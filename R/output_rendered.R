#' @title Render an rmarkdown file and output the result file.
#' @description Render an rmarkdown file, save the result file and eventually
#'     display the output in the browser or send the output to one or more
#'     email recipients.
#' @details The output can only be displayed in a browser or the R studio viewer
#'     in an interaktive session. If you chose to display the output in the
#'     R studio viewer, but it is not an R studio session, the output will
#'     instead be output in the browser.
#'
#'     An email with the results file can be sent to one or more recipients.
#'
#' @param input The path to the rmarkdown document.
#' @param output_file \[\code{character(1)}\]. The name of the output file.
#' @param output_dir \[\code{character(1)}\]. The directory to save the output file.
#' @param intermediates_dir \[\code{character(1)}\]. The directory to save
#'     intermediate files made by rmarkdown::render. Defaults to tempdir().
#' @param params \[\code{list}\]. List of parameters to be passed to the rmarkdown
#'     document. The parameters must have been defined in the YAML-section of the
#'     rmarkdown document.
#' @param display \[\code{logical(1)} |\code{character(1)}\]. If `FALSE`, don't
#'     display the results file. Can also be "browser" for the default browser
#'     or "viewer" for the R studio viewer. Defaults to `FALSE`.
#' @param email \[\code{logical(1)}\]. Whether an email with the results file
#'     should be sent or not. Defaults to `FALSE`.
#' @param from \[\code{character(1)}\]. The email address of the sender.
#' @param to \[\code{character}\]. The email address' of the recipients.
#' @param subject \[\code{character(1)}\]. Text in the subject line of the email.
#'     Defaults to the filename.
#' @param email_text \[\code{character(1)}\]\. Text to be written in the body of
#'     the email.
#' @param \dots Other arguments to be passed to `rmarkdown::render` and 
#'     `sendmailR::sendmail`.
#'
#' @export
#'
output_rendered <- function(input,
                            output_file,
                            output_dir,
                            intermediates_dir = tempdir(),
                            params,
                            display = FALSE,
                            email = FALSE,
                            from = NULL,
                            to = NULL,
                            subject = NULL,
                            email_text = NULL,
                            ...) {


  # Remove trailing backslash or slash before testing path
  output_dir <- sub("\\\\{1,2}$|/{1,2}$", "", output_dir)

  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Perform checks
  # checkmate::assert_file_exists(filename, access = "r")
  #
  # checkmate::assert_character(remove_allowed, min.chars = 1, any.missing = FALSE, null.ok = TRUE, add = checks)
  #
  # checkmate::assert_character(remove_after, len = 1, min.chars = 1, any.missing = FALSE, null.ok = TRUE, add = checks)

  # Report check-results
  checkmate::reportAssertions(checks)


  # RENDER DOCUMENT ----
  rmarkdown::render(input = input,
                    params = params,
                    output_file = output_file,
                    output_dir = output_dir,
                    intermediates_dir = intermediates_dir,
                    envir = new.env(parent = globalenv()),
                    encoding = "UTF-8",
                    quiet = TRUE,
                    ...)

  # OUTPUT IN BROWSER ----
  if (!isFALSE(display) && interactive()) {
    if (display == "viewer") {
      # Test whether running under RStudio
      if (Sys.getenv("RSTUDIO") == "1") {
        file.copy(from = file.path(output_dir, output_file), to = tempdir(), overwrite = TRUE)
        rstudioapi::viewer(file.path(tempdir(), output_file))
      } else {display <- "browser"}
    }

    if (display == "browser") {
      if (isTRUE(checkmate::checkOS("windows"))) {
        utils::browseURL(url = normalizePath(file.path(output_dir, output_file),
                                             winslash = "\\"),
                         browser = NULL)
      }
    }
  }

  # SEND FILE AS EMAIL
  if (isTRUE(email)) {
    # needs full path if not in working directory
    attachment_pathname <- normalizePath(file.path(output_dir, output_file),
                                         winslash = "\\")
    # key part for attachments, put the body and the mime_part in a list for msg
    attachment_object <- sendmailR::mime_part(x = attachment_pathname, name = output_file)
    body <- list(email_text, attachment_object)

    sendmailR::sendmail(from = from,
                        to = to,
                        subject = subject,
                        body = body,
                        control = list(smtpServer = "webmail.vetinst.no"),
                        ...)
  }
}
