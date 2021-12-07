#### SAVE SYSTEM DATA FOR PACKAGE NVIdb ----
### DESCRIPTION ----
# DESIGN
# There are two different types of system data prepared for this package
# 1. Connection parameters for databases
# 2. paths for catalogs with data at the NVI network
# The data for these are prepared and stored in sysdata.rda


### SET UP R ENVIRONMENT ----
# rm(list = ls())    # Benyttes for å tømme R-environment ved behov

# ACTIVATE PACKAGES
library(usethis)



### RUN SCRIPTS ----

NVIpkgs <- NVIpackager::NVIpackages[, "Package"]


### SAVE sysdata.rda ----

usethis::use_data(NVIpkgs,
                  internal = FALSE,
                  overwrite = TRUE)

# Clean environment to avoid conflicts between package and environment after running generate_sysdata
rm(list = c("NVIpkgs"))
