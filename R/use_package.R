#' @title Install and attach a package available at Cran
#' @description First, use_package checks if the package is installed. If not
#'     already installed, the package will be installed. Thereafter, the package
#'     is attached using library.
#' @details Only packages available at Cran can be installed.
#' @param pkg The name of the package.
#' @param repos Cran repository
#' @param \dots	Other arguments to be passed to install.packages.
#' @export
#' @examples
#' use_package("checkmate")

use_package <- function(pkg, repos = "https://cran.uib.no/", ...) {
  if (!nchar(system.file(package = pkg)))  {
    utils::install.packages(pkgs = pkg, repos = repos, ...)
  }
  library (package = pkg, character.only = TRUE)
}
