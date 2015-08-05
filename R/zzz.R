## Annoyingly, CRAN will not allow us to store the (open sourced!) C code 
## associated with the ISDA model in this package. So, we leave it (along with 
## some R wrappers) on github in package creditrISDA. If it is not installed, we
## need to install it. Is there a more elegant way to handle this?

#' @importFrom utils packageVersion

.onLoad <- function(libname, pkgname) {
  requireNamespace("utils")
  if(!"creditrISDA" %in% .packages(all.available = TRUE)){
    devtools::install_github("davidkane9/creditrISDA")
  }
}

## compress the vignette PDF to fix CMD Check WARNING
## The below works and please don't delete this!

Sys.setenv("_R_BUILD_COMPACT_VIGNETTES_" = "--compress-vignettes=gs+qpdf")