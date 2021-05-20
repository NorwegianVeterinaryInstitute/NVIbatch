# Alternative ways for installation of NVIverse packages

# library(devtools)

pkg <- "NVIbatch"

# The package must be detached to install it.
pkgname <- paste0("package:", pkg)
detach(pkgname, unload=TRUE, character.only = TRUE)


# Install from working directory
with_libpaths(paste0(Rlibrary,"/library"),
              install(sub("notes", "", dirname(rstudioapi::getSourceEditorContext()$path)),
                      dependencies = TRUE,
                      upgrade=FALSE,
                      build_vignettes = TRUE)
)

# Install from NorwegianVeterinaryInstitute at GitHub
remotes::install_github(paste0("NorwegianVeterinaryInstitute/", pkg),
                        upgrade = FALSE,
                        build = TRUE,
                        build_manual = TRUE,
                        build_vignettes = TRUE)


# Install from personal repository at GitHub
remotes::install_github(paste0("PetterHopp/", pkg),
                        upgrade = FALSE,
                        build = TRUE,
                        build_manual = TRUE,
                        build_vignettes = TRUE)


# # Install from binary file
# remove.packages("NVIdb")
# install.packages(pkgs = paste0(getwd(), "/..", "/NVIdb_", version, ".tar.gz"),
#                  type = "source",
#                  repos = NULL)

# install.packages(paste0(getwd(), "/..", "/NVIdb_", version, ".zip"),
#                  repos = NULL,
#                  type = "binary")

help(package = (pkg))
library(package = pkg, character.only = TRUE)

# install.packages(paste0(NVIconfig:::path_NVI["NVIverse"], "/NVIdb/Arkiv/NVIdb_0.1.7.zip"),
#                  repos = NULL,
#                  type = "binary")

