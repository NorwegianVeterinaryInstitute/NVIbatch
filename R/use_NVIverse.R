#' @title Attach and if necessary install packages within \code{NVIverse}
#' @description First, \code{use_NVIverse} checks if the package is installed. If not
#'     already installed, the package will be installed. Thereafter, the package
#'     is attached using library.
#' @details Only packages within the \code{NVIverse} can be installed.
#'
#' @param pkg [\code{character}]\cr
#'     Name of one or more \code{NVIverse} packages.
#' @param auth_token [\code{character}]\cr
#'     To install \code{NVIconfig} a personal access token is needed. Generate a personal
#'     access token (PAT) in "https://github.com/settings/tokens" and
#'     supply to this argument. Defaults to \code{NULL}.
#' @param dependencies [\code{logical(1) | character}]\cr
#' The dependencies to check and eventually install. Can be
#'     a character vector (selecting from "Depends", "Imports", "LinkingTo",
#'     "Suggests", or "Enhances"), or a logical vector. \code{TRUE} is shorthand
#'     for c("Depends", "Imports", "LinkingTo", "Suggests"). \code{FALSE} is
#'     shorthand for no dependencies, i.e. just check this package, not its
#'     dependencies. \code{NA} is shorthand for c("Depends", "Imports", "LinkingTo")
#'     and is the default.
#' @param upgrade [\code{logical(1) | character(1)}]\cr
#' Should package dependencies be upgraded? One of c("ask", "always", "never").
#'     \code{TRUE} and \code{FALSE} are also accepted and correspond to "always" and "never"
#'     respectively. Defaults to \code{FALSE}.
#' @param build [\code{logical(1)}]\cr
#' If \code{TRUE} build the package before installing. Defaults to \code{TRUE}.
#' @param build_manual [\code{logical(1)}]\cr
#' If \code{FALSE}, don't build PDF manual ('--no-manual').
#'     Defaults to \code{FALSE}.
#' @param build_vignettes [\code{logical(1)}]\cr
#' If \code{FALSE}, don't build package vignettes ("--no-build-vignettes").
#'     Defaults to \code{TRUE}.
#' @param \dots Other arguments to be passed to
#'     \ifelse{html}{\code{\link[remotes:install_github]{remotes::install_github}}}{\code{remotes::install_github}}.

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
  # checkmate::assert_subset(pkg,
  #                          choices = NVIrpackages::NVIpackages$Package,
  #                          add = checks)
  NVIcheckmate::assert_character(pkg,
                                 min.len = 1, min.chars = 3, 
                                 pattern = "^NVI.*|^OK.*",
                                 comment = "NVIverse package names start with 'NVI' or 'OK'",
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
