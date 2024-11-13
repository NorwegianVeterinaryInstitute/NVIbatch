# NVIbatch 0.5.1.9000 - (2024-##-##)

## New features:

-


## Bug fixes:

-


## Other changes:

-


## BREAKING CHANGES:

-


# NVIbatch 0.5.1 - (2024-11-12)

## New features:

- composing emails for `save_log` is improved with more robust generation of body text and possibility of attaching objects. Included the argument `email_subject`.


## Bug fixes:

- fixed error in `save_log` when no additional arguments were given.


## BREAKING CHANGES:

- argument `addtional_info` in `save_log` is deprecated. It is replaced by argument `include_text`.


# NVIbatch 0.5.0 - (2024-05-11)

### New features:

- Created `save_log` to simplify saving the log and sending an email with status after a batch script has been run.

- Improved collection of warnings and error messages for `gather_messages`. It now also collects messages marked with "fatal" that may occur when uploading data to certain services fail.


### Bug fixes:

- `gather_messages` now accepts input to `remove_allowed` with length larger than 1.


### Other changes:

- Improved and standardised help for all functions.


# NVIbatch 0.4.0 - (2022-12-13)

### New features:

- `output_rendered` render an rmarkdown document, saves the result file and eventually displays the result file in the browser or send it by email to one or more recipients.


# NVIbatch 0.3.1 - (2022-08-20)

### Other changes:
  
  - Improved argument checking in `use_NVIverse` by implementing `checkmate 2.1.0`.
  
  - Updated documentation including improved README installation guide.
  
  
### BREAKING CHANGES:
  
  - In `use_NVIverse` the default input for `build_manual` were changed to `build_manual = FALSE` to avoid problems that may occur if the pdf-file cannot be generated. 


# NVIbatch 0.3.0 - (2022-06-08)

### New features:
  
  - For `gather_messages` case is ignored for the arguments `remove_allowed =` and `remove_after =`. 
  

### Other changes:

  - Created the vignette: "Run R-scripts automatically". Thanks to Johan Åkerstedt for reviewing the draft of the vignette.
  
  - updated README


# NVIbatch 0.2.4 - (2022-01-20)

### Bug fixes:

  - Fixed problems with package dependencies during installation.


# NVIbatch 0.2.3 - (2021-11-30)

  Bug fixes:

  - `use_NVIverse` now installs missing NVIpackages if argument to `aut_token` is missing.


# NVIbatch 0.2.2 - (2021-10-01)

  Other changes:

  - Corrected installation instruction in README.


# NVIbatch 0.2.1 - (2021-09-28)

### Bug fixes:

  - `use_pkg` does not accept `repos` = `NULL` as input.

  - Solved problems with installation.


# NVIbatch 0.2.0 - (2021-09-07)

### New features:

  - `use_NVIverse` will attach and if necessary install a package within NVIverse. Accepts a vector of package names.

  - `use_pkg` now accepts a character vector with package names as input.


### Other changes:

  - Vignette for "Contributing to NVIbatch".

  - Improved argument checking.


# NVIbatch 0.1.1 - (2021-05-20)

### Bug fixes:

  - `gather_messages` now accepts `NULL` for `remove_allowed` and `remove_after`.


### BREAKING CHANGES:

  - renamed to `use_pkg` to avoid conflict with `usethis::use_package`.


# NVIbatch 0.1.0 - (2021-05-19)

### First release:

  - `use_package` Attach and if necessary install a package. The package needs to be available at Cran to be installed.

  - `gather_messages` Gather error and warning messages from the Rout-file.
