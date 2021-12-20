#' @title Identify old packages within NVIverse
#' @description old_NVIverse indicates packages within NVIverse that have a later version on the Github repository.
#' @details Only NVIverse packages that already are installed will be checked for even if more pkg are given as ibput to pkg.
#'
#' @param lib.loc character vector describing the location of R library trees to search through-out, or NULL for all known trees (see .libPaths).
#' @param pkg NVIverse packages that should be checked. Only packages listed and installed are checked. Defaults to all NVIverse packages.
#' @param auth_token
#' @export
#'

old_NVIverse <- function(lib.loc = NULL,
                         pkg = NVIpkgs,
                         auth_token = NULL) {

  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()

  # Check that NVIcheckmate is installed to avoid using NVIcheckmate functions if not installed
  NVIcheckmate_installed <- FALSE
  if (nchar(system.file(package = "NVIcheckmate"))) {NVIcheckmate_installed <- TRUE}

  # Perform checks
  # lib.loc
  checkmate::assert_character(lib.loc, null.ok = TRUE, add = checks)

  # pkg
  checkmate::assert_subset(pkg,
                           choices = NVIpkgs,
                           add = checks)
  # auth_token
  if ("NVIconfig" %in% pkg) {
    if (NVIcheckmate_installed) {
      NVIcheckmate::assert_character(auth_token,
                                     len = 1,
                                     any.missing = FALSE,
                                     null.ok = TRUE,
                                     comment = "You will need an personal authentication token to check version of NVIconfig",
                                     add = checks)
    }
    if (!NVIcheckmate_installed) {
      checkmate::assert_character(auth_token, len = 1, any.missing = FALSE, null.ok = FALSE, add = checks)
    }
  } else {
    checkmate::assert_character(auth_token, len = 1, any.missing = FALSE, null.ok = TRUE, add = checks)
  }

  # Report check-results
  checkmate::reportAssertions(checks)


  installed <- as.data.frame(utils::installed.packages(lib.loc = lib.loc))
  installed <- installed[which(installed[, "Package"] %in% pkg), ]
  # installed$gh_version <- NA
  for (i in 1:dim(installed)[1]) {
    # i <- 1
    gh_version <- gh::gh("GET /repos/NorwegianVeterinaryInstitute/{repo}/releases/latest",
                         repo = installed[i, "Package"])
    gh_version <- sub("[[:alpha:]]", "", gh_version[["tag_name"]])

    installed[i, "gh_version"] <- paste(stringr::word(gh_version, start = 1, end = 3, sep = "\\."), collapse = "\\.")

    installed[i, "Version"] <- paste(stringr::word(installed[i, "Version"], start = 1, end = 3, sep = "\\."), collapse = "\\.")

    installed[i, "compare"] <- utils::compareVersion(installed[i, "Version"], installed[i, "gh_version"])
  }
  installed <- subset(installed[, c("Package", "Version", "gh_version")], installed$compare == -1)
  # if (dim(installed)[1] == 0) {installed <- NULL}
  return(installed)
}


# library (gh)
# old_NVIverse <- function(pkg) {
#   for (i in pkg) {
# releases <- gh::gh("GET /repos/NorwegianVeterinaryInstitute/{repo}/releases/latest",
#                    repo = "NVIdb")
# gh_version <- sub("[[:alpha:]]","",releases[["tag_name"]])
# pc_version <- utils::packageVersion("NVIdb")
# # utils::compareVersion(gh_version, pc_version)
# utils::compareVersion(gh_version, "0.6.0-beta")
# }
# }
