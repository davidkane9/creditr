.onLoad <- function(libname, pkgname) {
  
  ## compress the vignette PDF to fix CMD Check WARNING
  ## The below works and please don't delete this!
  
  Sys.setenv("_R_BUILD_COMPACT_VIGNETTES_" = "gs+qpdf")
  
  ## do not check suggests package (creditrISDA) dependency 
  
  Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = FALSE)
}