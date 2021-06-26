NVIbatch: Tools to facilitate the running of R-scripts in batch mode at NVI
================

  - [Overview](#overview)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Copyright and license](#copyright-and-license)
  - [Contributing](#contributing)

# Overview
`NVIbatch` comprises functions to facilitate the writing of batch R-scripts that
should be run automatically at specific times. 

# Installation

`NVIbatch` is available at https://github.com/NorwegianVeterinaryInstitute. 
To install `NVIbatch` you will need:
  - R version > 4.0.0
  - R package `devtools`
  - Rtools 4.0

First install and attach the `devtools` package.  

``` r
install.packages("devtools")
library(devtools)
```

To install (or update) the `NVIcheckmate` package, run the following code:

``` r
remotes::install_github("NorwegianVeterinaryInstitute/NVIbatch", 
	upgrade = FALSE, 
	build = TRUE,
	build_manual = TRUE)
```

# Usage
To come.

# Copyright and license
Copyright 2021 Norwegian Veterinary Institute

Licensed under the BSD 3-Clause License (the "License"); The files in `NVIbatch` 
can be used in compliance with the [License](https://opensource.org/licenses/BSD-3-Clause).

# Contributing

Contributions to develop `NVIbatch` is highly appreciated. You may, for example, 
contribute by reporting a bug, fixing documentation errors, contributing new code, 
or commenting on issues/pull requests. 

-----

Please note that the NVIbatch project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By 
contributing to this project, you agree to abide by its terms.
