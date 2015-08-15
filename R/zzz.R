.onLoad <- function(libname, pkgname) {
  
  ## compress the vignette PDF to fix CMD Check WARNING
  ## The below works and please don't delete this!
  
  Sys.setenv("_R_BUILD_COMPACT_VIGNETTES_" = "qpdf")
}

.onAttach <- function(...) {
  packageStartupMessage(
    "\nIF YOU USE THIS creditr PACKAGE, YOUR USE WILL SIGNIFY YOUR
    UNDERSTANDING AND IRREVOCABLE ACCEPTANCE OF THIS LICENSE AND ITS
    TERMS, WHICH INCORPORATE BY REFERENCE THE INTERNATIONAL SWAPS AND
    DERIVATIVES ASSOCIATION, INC.'S CDS STANDARD MODEL PUBLIC LICENSE,
    WHICH IS AVAILABLE AT
    http://www.cdsmodel.com/cdsmodel/cds-disclaimer.page 
    before using the package.
    \nNOTHING IN THIS LICENSE RESTRICTS YOUR ABILITY TO USE
    THE ISDA(R) CDS STANDARD MODEL.
    \nDISCLAIMER: ISDA HAS NEITHER REVIEWED, APPROVED NOR ENDORSED THE 
    USE OF THE creditr PACKAGE. THOSE PERSONS USING THIS CDS PACKAGE 
    ARE ENCOURAGED TO SEEK THE ADVICE OF A LEGAL PROFESSIONAL TO EVALUATE 
    ITS SUITABILITY FOR THEIR USE.
    \nISDA(R) is a registered mark of the International Swaps and
    Derivatives Association, Inc.")
}
