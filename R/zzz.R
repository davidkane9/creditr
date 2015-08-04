## Annoyingly, CRAN will not allow us to store the (open sourced!) C code 
## associated with the ISDA model in this package. So, we leave it (along with 
## some R wrappers) on github in package creditrISDA. If it is not installed, we
## need to install it. Is there a more elegant way to handle this?

.onLoad <- function(libname, pkgname) {
  if(!"creditrISDA" %in% .packages(all.available = TRUE)){
    devtools::install_github("davidkane9/creditrISDA")
  }
}

## compress the vignette PDF to fix CMD Check WARNING

Sys.setenv("_R_BUILD_COMPACT_VIGNETTES_" = "--compress-vignettes=gs+qpdf")