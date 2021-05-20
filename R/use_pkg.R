#' @title Attach and if necessary install a package
#' @description First, use_package checks if the package is installed. If not
#'     already installed, the package will be installed. Thereafter, the package
#'     is attached using library.
#' @details Only packages available at Cran can be installed.
#' @param pkg The name of the package.
#' @param repos character vector, the base URL(s) of the repositories to use,
#'     e.g., the URL of a CRAN mirror such as "https://cloud.r-project.org". Can
#'     be NULL to install from local files, directories or URLs: this will be
#'     inferred by extension from pkgs if of length one.
#' @param \dots	Other arguments to be passed to install.packages.
#' @export
#' @examples
#' use_pkg("checkmate")

use_pkg <- function(pkg, repos = "https://cran.uib.no/", ...) {
  if (!nchar(system.file(package = pkg)))  {
    utils::install.packages(pkgs = pkg, repos = repos, ...)
  }
  library (package = pkg, character.only = TRUE)
}
