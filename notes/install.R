# Alternative ways for installation of NVIverse packages

# library(devtools)

pkg <- "NVIdb"

# The package must be detached to install it.
pkgname <- paste0("package:", pkg)
detach(pkgname, unload=TRUE, character.only = TRUE)


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


# install.packages(paste0(NVIconfig:::path_NVI["NVIverse"], "/NVIdb/Arkiv/NVIdb_0.1.7.zip"),
#                  repos = NULL,
#                  type = "binary")

