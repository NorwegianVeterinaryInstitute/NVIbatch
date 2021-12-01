#' @title Identify old packages within NVIverse


library (gh)
old_NVIverse <- function(pkg) {
  for (i in pkg) {
releases <- gh::gh("GET /repos/NorwegianVeterinaryInstitute/{repo}/releases/latest",
                   repo = "NVIdb")
gh_version <- sub("[[:alpha:]]","",releases[["tag_name"]])
pc_version <- utils::packageVersion("NVIdb")
# utils::compareVersion(gh_version, pc_version)
utils::compareVersion(gh_version, "0.6.0-beta")
}
}
