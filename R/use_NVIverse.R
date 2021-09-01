#' @title Attach and if necessary install packages within NVIverse
#' @description First, use_NVIverse checks if the package is installed. If not
#'     already installed, the package will be installed. Thereafter, the package
#'     is attached using library.
#' @details Only packages within NVIverse are installed.
#' @param pkg A vector with the name of one or more NVIverse packages.
#' @param auth_token To install NVIconfig a personal access token is needed. Generate a personal
#'     access token (PAT) in "https://github.com/settings/tokens" and
#'     supply to this argument. Defaults to \code{NA}.
#' @param dependencies The dependencies to check and eventually install. Can be
#'     a character vector (selecting from "Depends", "Imports", "LinkingTo",
#'     "Suggests", or "Enhances"), or a logical vector. \code{TRUE} is shorthand
#'     for c("Depends", "Imports", "LinkingTo", "Suggests"). \code{FALSE} is
#'     shorthand for no dependencies, i.e. just check this package, not its
#'     dependencies. \code{NA} is shorthand for c("Depends", "Imports", "LinkingTo")
#'     and is the default.
#' @param upgrade Should package dependencies be upgraded? One of "ask", "always", or "never".
#'     \code{TRUE} and \code{FALSE} are also accepted and correspond to "always" and "never"
#'     respectively. Defaults to \code{FALSE}.
#' @param build If \code{TRUE} build the package before installing. Defaults to \code{TRUE}.
#' @param build_manual If \code{FALSE}, don't build PDF manual ('--no-manual').
#'     Defaults to \code{TRUE}.
#' @param build_vignettes If \code{FALSE}, don't build package vignettes ('--no-build-vignettes').
#'     Defaults to \code{TRUE}.
#' @param \dots Other arguments to be passed to install_github.

#' @export
#' @examples
#' use_NVIverse("NVIcheckmate")
#' use_NVIverse(pkg = c("NVIcheckmate", "NVIdb"))


use_NVIverse <- function(pkg,
                         auth_token = NA,
                         dependencies = NA,
                         upgrade = FALSE,
                         build = TRUE,
                         build_manual = TRUE,
                         build_vignettes = TRUE,
                         ... ) {
  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Perform checks
  # package
  checkmate::assert_subset(pkg,
                           choices = c("NVIbatch", "NVIconfig", "NVIdb", "NVIpretty", "NVIcheckmate", "OKplan", "OKcheck"),
                           add = checks)
  # PAT
  checkmate::assert_character(auth_token, null.ok = TRUE, add = checks)
  NVIcheckmate::assert(checkmate::check_logical(dependencies),
                       checkmate::check_subset(dependencies,
                                               choices = c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")),
                       combine = "or",
                       add = checks)
  NVIcheckmate::assert(checkmate::check_logical(upgrade),
                       checkmate::check_choice(upgrade, choices = c("ask", "always", "never")),
                       combine = "or",
                       add = checks)
  checkmate::assert_logical(build, add = checks)
  checkmate::assert_logical(build_manual, add = checks)
  checkmate::assert_logical(build_vignettes, add = checks)

  # Report check-results
  checkmate::reportAssertions(checks)


  # For NVIdb::get_PAT NVIdb::set_PAT must previously have been run at the current PC for the current user
  #   set_PAT and get_PAT are only available in NVIdb v0.1.8 and later.
  # set_PAT("GitHub")


  # RUN SCRIPT ----
  # ATTACH PACKAGE ----
  for (i in length(pkg)) {
    if (!nchar(system.file(package = pkg[i])))  {
      # Install from NorwegianVeterinaryInstitute at GitHub
      remotes::install_github(paste0("NorwegianVeterinaryInstitute/", pkg[i]),
                              auth_token = auth_token,
                              upgrade = upgrade,
                              build = build,
                              build_manual = build_manual,
                              build_vignettes = build_vignettes,
                              dependencies = dependencies,
                              ... )
    }
    library (package = pkg[i], character.only = TRUE)
  }
}

