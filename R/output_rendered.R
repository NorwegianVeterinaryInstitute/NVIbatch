#' @title Render an rmarkdown file and output the result file.
#' @description Render an rmarkdown file, save the result file and eventually
#'     display the output in the browser or send the output to one or more
#'     email recipients.
#' @details The input to the argument \code{params} should be a list with
#'     parameters that is used by the rmarkdown document. The parameters must
#'     have been defined in the YAML-section of the rmarkdown document.
#'
#'     The default behaviour is to save the resulting html-file in the
#'     temporary directory. To save the result in a permanent file, use a
#'     permanent directory as input to \code{output_dir}.
#'
#'     The output can only be displayed in a browser or the R studio viewer
#'     in an interactive session. If you chose to display the output in the
#'     R studio viewer, but it is not an R studio session, the output will
#'     instead be output in the browser.
#'
#'     An email with the results file can be sent to one or more recipients.
#'
#' @param input [\code{character(1)}]\cr
#'     The path to the rmarkdown document.
#' @param output_file [\code{character(1)}]\cr
#'     The name of the output file.
#' @param output_dir [\code{character(1)}]\cr
#'     The directory to save the output file. Defaults to \code{tempdir()}.
#' @param intermediates_dir [\code{character(1)}]\cr
#'     The directory to save intermediate files made by
#'     \ifelse{html}{\code{\link[rmarkdown:render]{rmarkdown::render}}}{\code{rmarkdown::render}}.
#'     Defaults to \code{tempdir()}.
#' @param params [\code{list}]\cr
#'     List of parameters to be passed to the rmarkdown document.
#' @param display [\code{logical(1) | character(1)}]\cr
#'     If \code{FALSE}, don't display the results file. Can also be
#'     \code{"browser"} for the default browser or \code{"viewer"} for the R studio
#'     viewer. \code{TRUE} equals \code{"browser"}. Defaults to \code{FALSE}.
#' @param email [\code{logical(1)}]\cr
#'     Whether an email with the results file should be sent or not.
#'     Defaults to \code{FALSE}.
#' @param from [\code{character(1)}]\cr
#'     The email address of the sender. Defaults to \code{NULL}.
#' @param to [\code{character}]\cr
#'     The email address' of the recipients. Defaults to \code{NULL}.
#' @param subject [\code{character(1)}]\cr
#'     Text in the subject line of the email. Defaults to \code{NULL}.
#' @param email_text [\code{character(1)}]\cr
#'     Text to be written in the body of the email. Defaults to \code{NULL}.
#' @param \dots Other arguments to be passed to
#'     \ifelse{html}{\code{\link[rmarkdown:render]{rmarkdown::render}}}{\code{rmarkdown::render}} and
#'     \ifelse{html}{\code{\link[sendmailR:sendmail]{sendmailR::sendmail}}}{\code{sendmailR::sendmail}}.
#'
#' @return None. Render a rmarkdown file and either saves, emails
#'     or displays it in the browser.
#'
#' @author Petter Hopp Petter.Hopp@@vetinst.no
#' @export
#'
output_rendered <- function(input,
                            output_file,
                            output_dir = tempdir(),
                            intermediates_dir = tempdir(),
                            params,
                            display = FALSE,
                            email = FALSE,
                            from = NULL,
                            to = NULL,
                            subject = NULL,
                            email_text = NULL,
                            ...) {


  # PREPARE ARGUMENTS BEFORE CHECKING ----
  if (isTRUE(display)) {display = "browser"}
  # Remove trailing backslash or slash before testing path
  output_dir <- sub("\\\\{1,2}$|/{1,2}$", "", output_dir)

  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Perform checks
  checkmate::assert_file(input, access = "r", add = checks)
  checkmate::assert_string(output_file, min.chars = 1, add = checks)
  checkmate::assert_directory(output_dir, access = "r", add = checks)
  checkmate::assert_directory(intermediates_dir, access = "r", add = checks)
  checkmate::assert_list(params, add = checks)
  checkmate::assert(checkmate::check_false(display),
                    checkmate::check_choice(display, choices = c("browser", "viewer")),
                    add = checks)
  checkmate::assert_flag(email, add = checks)
  #
  NVIcheckmate::assert_character(from,
                                 len = 1, min.chars = 5, max.chars = 256,
                                 pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", ignore.case = TRUE,
                                 null.ok = TRUE,
                                 comment = "The email address is not valid",
                                 add = checks)
  NVIcheckmate::assert_character(to,
                                 min.len = 1, min.chars = 5, max.chars = 256,
                                 pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", ignore.case = TRUE,
                                 null.ok = TRUE,
                                 comment = "One or more email address' are not valid",
                                 add = checks)
  checkmate::assert_string(subject, null.ok = TRUE, add = checks)
  checkmate::assert_string(email_text, null.ok = TRUE, add = checks)
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
    if (!is.null(email_text)) {
      body <- list(email_text, attachment_object)
    } else {
      body <- list(attachment_object)
    }

    sendmailR::sendmail(from = from,
                        to = to,
                        subject = subject,
                        msg = body,
                        control = list(smtpServer = "webmail.vetinst.no"),
                        ...)
  }
}
