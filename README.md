NVIbatch: Tools to facilitate the running of R-scripts in batch mode at NVI
===========================================================================

<!-- README.md is generated from README.Rmd. Please edit that file -->

-   [Overview](#overview)
-   [Installation](#installation)
-   [Usage](#usage)
-   [Copyright and license](#copyright-and-license)
-   [Contributing](#contributing)

Overview
========

`NVIbatch` provide tools to facilitate the writing of batch R-scripts
that should be run automatically at specific times.

`NVIbatch` as part of `NVIverse`, a collection of R-packages with tools
to facilitate data management and data reporting at the Norwegian
Veterinary Institute (NVI).

#### Table 1. NVIverse packages

<table>
<colgroup>
<col style="width: 13%" />
<col style="width: 8%" />
<col style="width: 78%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Package</th>
<th style="text-align: left;">Status</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">NVIconfig</td>
<td style="text-align: left;">Private</td>
<td style="text-align: left;">Configuration information necessary for some NVIverse functions</td>
</tr>
<tr class="even">
<td style="text-align: left;">NVIdb</td>
<td style="text-align: left;">Public</td>
<td style="text-align: left;">Tools to facilitate the use of NVI’s databases</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NVIpretty</td>
<td style="text-align: left;">Public</td>
<td style="text-align: left;">Tools to make R-output pretty in accord with NVI’s graphical profile</td>
</tr>
<tr class="even">
<td style="text-align: left;">NVIbatch</td>
<td style="text-align: left;">Public</td>
<td style="text-align: left;">Tools to facilitate the running of R-scripts in batch mode at NVI</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NVIcheckmate</td>
<td style="text-align: left;">Public</td>
<td style="text-align: left;">Extension of checkmate with argument checking adapted for NVIverse</td>
</tr>
<tr class="even">
<td style="text-align: left;">OKplan</td>
<td style="text-align: left;">Public</td>
<td style="text-align: left;">Tools to facilitate the planning of surveillance programmes for the NFSA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">OKcheck</td>
<td style="text-align: left;">Public</td>
<td style="text-align: left;">Tools to facilitate checking of data from national surveillance programmes</td>
</tr>
</tbody>
</table>

Installation
============

`NVIbatch` is available at
[GitHub](https://github.com/NorwegianVeterinaryInstitute). To install
`NVIbatch` you will need:

-   R version &gt; 4.0.0
-   R package `devtools`
-   Rtools 4.0

First install and attach the `devtools` package.

    install.packages("devtools")
    library(devtools)

To install (or update) the `NVIbatch` package, run the following code:

    remotes::install_github(NorwegianVeterinaryInstitute/NVIbatch)
        upgrade = FALSE,
        build = TRUE,
        build_manual = TRUE)

Usage
=====

To come.

Copyright and license
=====================

Copyright (c) 2021 Norwegian Veterinary Institute  
Licensed under the BSD 3-Clause
[License](https://github.com/NorwegianVeterinaryInstitute/NVIbatch/blob/main/LICENSE).

Contributing
============

Contributions to develop `NVIbatch` is highly appreciated. There are
several ways you can contribute to this project: ask a question, propose
an idea, report a bug, improve the documentation, or contribute code.
The vignette “Contribute to NVIbatch” gives more information.

------------------------------------------------------------------------

Please note that the NVIbatch project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
