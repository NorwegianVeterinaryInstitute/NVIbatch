#' @title Attach and if necessary install a package
#' @description First, \code{use_package} checks if the package is installed. If not
#'     already installed, the package will be installed. Thereafter, the package
#'     is attached using library.
#' @details Only packages available at Cran can be installed.
#' @param pkg [\code{character}]\cr
#'     Name of one or more packages.
#' @param repos [\code{character(1)}]\cr
#'     The base URL(s) of the repositories to use, e.g., the URL of
#'     a Cran mirror such as "https://cloud.r-project.org". Can be
#'     \code{NULL} to install from local files, directories or URLs:
#'     this will be inferred by extension from pkgs if of length one.
#'     Defaults to "https://cran.uib.no/".
#' @param \dots	Other arguments to be passed to
#'     \ifelse{html}{\code{\link[utils:install.packages]{utils::install.packages}}}{\code{utils::install.packages}}.
#' @export
#' @examples
#' use_pkg("checkmate")
#' use_pkg(pkg = c("checkmate", "devtools"))
#'
use_pkg <- function(pkg, repos = "https://cran.uib.no/", ...) {

  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Perform checks
  checkmate::assert_character(pkg, min.chars = 1, any.missing = FALSE, min.len = 1, add = checks)

  checkmate::assert_string(repos, min.chars = 1, add = checks)

  # Report check-results
  checkmate::reportAssertions(checks)

  # RUNNING SCRIPT ----
  for (i in pkg) {
    if (!nchar(system.file(package = i))) {
      utils::install.packages(pkgs = i, repos = repos, ...)
    }
    library(package = i, character.only = TRUE)
  }
}
