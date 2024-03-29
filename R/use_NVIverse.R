#' @title Attach and if necessary install packages within `NVIverse`
#' @description First, `use_NVIverse` checks if the package is installed. If not
#'     already installed, the package will be installed. Thereafter, the package
#'     is attached using library.
#' @details Only packages within the `NVIverse` can be installed.
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

#' @export
#' @examples
#' use_NVIverse("NVIcheckmate")
#' use_NVIverse(pkg = c("NVIcheckmate", "NVIdb"))
use_NVIverse <- function(pkg,
                         auth_token = NULL,
                         dependencies = NA,
                         upgrade = FALSE,
                         build = TRUE,
                         build_manual = FALSE,
                         build_vignettes = TRUE,
                         ...) {
  # ARGUMENT CHECKING ----
  # Check that NVIcheckmate is installed to avoid using NVIcheckmate functions if not installed
  NVIcheckmate_installed <- FALSE
  if (nchar(system.file(package = "NVIcheckmate"))) {NVIcheckmate_installed <- TRUE}

  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Perform checks
  # pkg
  checkmate::assert_subset(pkg,
                           choices = NVIrpackages::NVIpackages$Package,
                           add = checks)
  # auth_token
  if ("NVIconfig" %in% pkg & !nchar(system.file(package = "NVIconfig"))) {
    if (NVIcheckmate_installed) {
      NVIcheckmate::assert_character(auth_token,
                                     len = 1,
                                     any.missing = FALSE,
                                     null.ok = TRUE,
                                     comment = "You will need an personal authentication token to install NVIconfig",
                                     add = checks)
    }
    if (!NVIcheckmate_installed) {
      checkmate::assert_character(auth_token, len = 1, any.missing = FALSE, null.ok = TRUE, add = checks)
    }
  } else {
    checkmate::assert_character(auth_token, len = 1, any.missing = FALSE, null.ok = TRUE, add = checks)

  }

  # if (NVIcheckmate_installed) {
  # dependencies
  checkmate::assert(checkmate::check_flag(dependencies, na.ok = TRUE),
                    checkmate::check_subset(dependencies,
                                            choices = c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")),
                    combine = "or",
                    add = checks)
  # upgrade
  checkmate::assert(checkmate::check_flag(upgrade),
                    checkmate::check_choice(upgrade, choices = c("ask", "always", "never")),
                    combine = "or",
                    add = checks)
  # }
  # build
  checkmate::assert_flag(build, add = checks)
  # build_manual
  checkmate::assert_flag(build_manual, add = checks)
  # build_vignettes
  checkmate::assert_flag(build_vignettes, add = checks)

  # Report check-results
  checkmate::reportAssertions(checks)

  # if (!NVIcheckmate_installed) {
  #   # dependencies
  #   checkmate::assert(checkmate::check_flag(dependencies),
  #                     checkmate::check_subset(dependencies,
  #                                             choices = c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")),
  #                     combine = "or")
  #   # upgrade
  #   checkmate::assert(checkmate::check_flag(upgrade),
  #                     checkmate::check_choice(upgrade, choices = c("ask", "always", "never")),
  #                     combine = "or")
  # }


  # RUN SCRIPT ----

  # ATTACH PACKAGE ----
  # run for each package separately, library doesn't accept vectorized input
  for (i in pkg) {
    if (!nchar(system.file(package = i))) {
      # Install from NorwegianVeterinaryInstitute at GitHub if needed
      remotes::install_github(paste0("NorwegianVeterinaryInstitute/", i),
                              auth_token = auth_token,
                              upgrade = upgrade,
                              build = build,
                              build_manual = build_manual,
                              build_vignettes = build_vignettes,
                              dependencies = dependencies,
                              ...)
    }
    library(package = i, character.only = TRUE)
  }
}
