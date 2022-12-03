#' @title Attach and if necessary install packages within `NVIverse`
#' @description First, `use_NVIverse` checks if the package is installed. If not
#'     already installed, the package will be installed. Thereafter, the package
#'     is attached using library.
#' @details Only packages within the `NVIverse` can be installed.
#' 
#' @param pkg A vector with the name of one or more `NVIverse` packages.
#' @param auth_token To install `NVIconfig` a personal access token is needed. Generate a personal
#'     access token (PAT) in "https://github.com/settings/tokens" and
#'     supply to this argument. Defaults to \code{NULL}.
#' @param dependencies \[\code{logical(1)}\] or \[\code{character}\]\cr
#' The dependencies to check and eventually install. Can be
#'     a character vector (selecting from "Depends", "Imports", "LinkingTo",
#'     "Suggests", or "Enhances"), or a logical vector. `TRUE` is shorthand
#'     for c("Depends", "Imports", "LinkingTo", "Suggests"). `FALSE` is
#'     shorthand for no dependencies, i.e. just check this package, not its
#'     dependencies. \code{NA} is shorthand for c("Depends", "Imports", "LinkingTo")
#'     and is the default.
#' @param upgrade \[\code{logical(1)}\] or \[\code{character}\]\cr
#' Should package dependencies be upgraded? One of "ask", "always", or "never".
#'     `TRUE` and `FALSE` are also accepted and correspond to "always" and "never"
#'     respectively. Defaults to `FALSE`.
#' @param build \[\code{logical(1)}\]\cr
#' If `TRUE` build the package before installing. Defaults to `TRUE`.
#' @param build_manual \[\code{logical(1)}\]\cr
#' If `FALSE`, don't build PDF manual ('--no-manual').
#'     Defaults to `FALSE`.
#' @param build_vignettes \[\code{logical(1)}\]\cr
#' If `FALSE`, don't build package vignettes ("--no-build-vignettes").
#'     Defaults to `TRUE`.
#' @param \dots Other arguments to be passed to `install_github`.
#' 
#' @export
#' @examples
#' use_NVIverse("NVIcheckmate")
#' use_NVIverse(pkg = c("NVIcheckmate", "NVIdb"))
#' 
output_rendered <- function (data,
                             input_Rmd,
                             output_file,
                             output_dir,
                             intermediates_dir = tempdir(),
                             display = FALSE, 
                             email =FALSE, 
                             from = NULL, 
                             to = NULL, 
                             subject = NULL, 
                             email_text = NULL) {
  
  
  # Remove trailing backslash or slash before testing path
  filepath <- sub("\\\\{1,2}$|/{1,2}$", "", filepath)
  
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
  rmarkdown::render(input_Rmd,
                    output_file = output_file,
                    output_dir = output_dir,
                    intermediates_dir = intermediates_dir,
                    envir = new.env(parent = globalenv()),
                    encoding = "UTF-8",
                    quiet = TRUE)
  
  # OUTPUT IN BROWSER ---- 
  if (!isFALSE(display) && interactive()) {
    if (display == "viewer") {
      # Test whether running under RStudio
      if (Sys.getenv("RSTUDIO") == "1") {
        
      } else {display <- "browser"} 
    }
    
    if (display == "browser") {
      if (isTRUE(checkOS("windows"))) {
        browseURL(url = normalizePath(file.path(output_dir, output_file),
                                      winslash = "\\"),
                  browser = NULL)
      }
    }
  }
  
  # SEND FILE AS EMAIL 
  if (isTRUE(email)) {
    #needs full path if not in working directory
    attachmentPathName <- normalizePath(file.path(output_dir, output_file),
                                        winslash = "\\") 
    attachmentName <- output_file
    
    #key part for attachments, put the body and the mime_part in a list for msg
    attachmentObject <- mime_part(x = attachmentPathName, name = attachmentName)
    body <- list(email_text, attachmentObject)
    
    sendmail(from = from, 
             to = to, 
             subject = subject , 
             body = body, 
             control = list(smtpServer = "webmail.vetinst.no"))
  } 
} 

