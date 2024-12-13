# https://cran.r-project.org/web/packages/this.path/this.path.pdf
this.path::this.path()


library(NVIdb)

# BATCH ON SERVER RUNNING BY R.exe
# Globale variabler
CWDEOSdomene <- paste0(set_dir_NVI("FAG"),"Landdyr/Vilt/Sykdommer/CWD/PJSrapporter/EOSdata/")
# saveRDS(command_args, file = paste0(CWDEOSdomene, "Rscripts/", "command_args.RDS"))
command_args <- readRDS(file = paste0(CWDEOSdomene, "Rscripts/", "command_args.RDS"))
command_args
[1] "C:\\PROGRA~1\\R\\R-40~1.2/bin/x64/Rterm.exe"                                                                                            
[2] "-f"                                                                                                                                     
[3] "\\\\vetinst.no\\dfs-felles\\felles02\\FAG\\Landdyr\\Vilt\\Sykdommer\\CWD\\PJSrapporter\\EOSdata\\Rscripts\\Batch CWDrapporter fra EOS.R"
[4] "--restore"                                                                                                                              
[5] "--save"

# BATCH ON SERVER RUNNING BY Rscript.exe
repository <- "SurveillancePrepare"
scripts <- paste0(set_dir_NVI("OKprogrammer"),"GitHub/",repository,"/")
# saveRDS(object = test_commandArgs, file = paste0(scripts, "test_commandArgs.rds"))
test_commandArgs <- readRDS(file = paste0(scripts, "test_commandArgs.rds"))
test_commandArgs
[1] "C:\\Program Files\\R\\R-4.2.2\\bin\\x64\\Rterm.exe"                                                                       
[2] "--no-echo"                                                                                                                
[3] "--no-restore"                                                                                                             
[4] "--file=\\\\vetinst.no\\dfs-felles\\felles02\\FAG\\OKprogrammer\\GitHub\\SurveillancePrepare\\Batch OKdata til AppOKstat.R"

# INTERACTIVE in R-studio
interactive()
TRUE
commandArgs()
[1] "RStudio"       "--interactive"

rstudioapi::getSourceEditorContext()$path
[1] "//vetinst.no/dfs-felles/StasjonK/FAG/OKprogrammer/GitHub/SurveillancePrepare/Batch OKdata til AppOKstat.R"

# INTERACTIVE in R.exe
interactive()
TRUE
"C:\\Program Files\\R\\R-4.2.1\\bin\\x64\\Rgui.exe" "--cd-to-userdocs"   

interactive()
TRUE
Sys.getenv("RSTUDIO")
[1] "1"
Sys.getenv("COMPUTERNAME")
[1] "VIO-D-8DKGG52"

sessionInfo()

test <- Sys.info()
class(test)
[1] "character"
test
sysname         release         version        nodename         machine           login            user  effective_user 
"Windows"        "10 x64"   "build 18362" "VIO-D-8DKGG52"        "x86-64"        "13hopp"        "13hopp"        "13hopp" 
test["nodename"]
nodename 
"VIO-D-8DKGG52" 


# https://stackoverflow.com/questions/47044068/get-the-path-of-current-script
library(tidyverse)
getCurrentFileLocation <-  function()
{
  this_file <- commandArgs()  |>  
    tibble::enframe(name = NULL) |>
    tidyr::separate(col=value, into=c("key", "value"), sep="=", fill='right') |>
    dplyr::filter(key == "--file") |>
    dplyr::pull(value)
  if (length(this_file)==0)
  {
    this_file <- rstudioapi::getSourceEditorContext()$path
  }
  
  stub <- function() {}
  thisPath <- function() {
    cmdArgs <- commandArgs(trailingOnly = FALSE)
    if (length(grep("^-f$", cmdArgs)) > 0) {
      # R console option
      normalizePath(dirname(cmdArgs[grep("^-f", cmdArgs) + 1]))[1]
    } else if (length(grep("^--file=", cmdArgs)) > 0) {
      # Rscript/R console option
      scriptPath <- normalizePath(dirname(sub("^--file=", "", cmdArgs[grep("^--file=", cmdArgs)])))[1]
    } else if (Sys.getenv("RSTUDIO") == "1") {
      # RStudio
      dirname(rstudioapi::getSourceEditorContext()$path)
    } else if (is.null(attr(stub, "srcref")) == FALSE) {
      # 'source'd via R console
      dirname(normalizePath(attr(attr(stub, "srcref"), "srcfile")$filename))
    } else {
      stop("Cannot find file path")
    }
  }
  
  return(dirname(this_file))
}

# https://stackoverflow.com/questions/1815606/determine-path-of-the-executing-script
thisFile <- function() {
  cmdArgs <- commandArgs(trailingOnly = FALSE)
  needle <- "--file="
  match <- grep(needle, cmdArgs)
  if (length(match) > 0) {
    # Rscript
    return(normalizePath(sub(needle, "", cmdArgs[match])))
  } else {
    # 'source'd via R console
    return(normalizePath(sys.frames()[[1]]$ofile))
  }
}


# https://stackoverflow.com/questions/49196697/how-to-get-the-directory-of-the-executing-script-in-r
library(base)
library(rstudioapi)

get_directory <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file <- "--file="
  rstudio <- "RStudio"
  
  match <- grep(rstudio, args)
  if (length(match) > 0) {
    return(dirname(rstudioapi::getSourceEditorContext()$path))
  } else {
    match <- grep(file, args)
    if (length(match) > 0) {
      return(dirname(normalizePath(sub(file, "", args[match]))))
    } else {
      return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
    }
  }
}