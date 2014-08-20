.onAttach <- function(...) {
  
  packageStartupMessage(
  "IF YOU USE THIS CDS PACKAGE, YOUR USE WILL SIGNIFY YOUR 
  UNDERSTANDING AND IRREVOCABLE ACCEPTANCE OF THIS LICENSE AND ITS 
  TERMS, WHICH INCORPORATE BY REFERENCE THE INTERNATIONAL SWAPS AND 
  DERIVATIVES ASSOCIATION, INC.'S CDS STANDARD MODEL PUBLIC LICENSE,
  WHICH IS AVAILABLE AT 
  http://www.cdsmodel.com/cdsmodel/cdsdisclaimer.page before using 
  the package. NOTHING IN THIS LICENSE RESTRICTS YOUR ABILITY TO 
  USE THE ISDA(R) CDS STANDARD MODEL. DISCLAIMER: ISDA HAS 
  NEITHER REVIEWED, APPROVED NOR ENDORSED THE USE OF THE CDS 
  PACKAGE. THOSE PERSONS USING THIS CDS PACKAGE ARE ENCOURAGED TO 
  SEEK THE ADVICE OF A LEGAL PROFESSIONAL TO EVALUATE ITS 
  SUITABILITY FOR THEIR USE. ISDA(R) is a registered mark of the 
  International Swaps and Derivatives Association, Inc. Please 
  type **yes** to assent to the aforementioned terms.")
    
    if(interactive()){
      while (readLines(n=1)!="yes")
        packageStartupMessage("Please type **yes** to assent to the 
                              aforementioned terms.")
    }
  message(
  "Due to CRAN regulations, we cannot include ISDA C-code in
   our package. To continue using this package, please go to 
   http://www.cdsmodel.com/cdsmodel/cds-disclaimer.html?
   to first download the ISDA CDS Standard Model, and install it
   into the /src folder in the CDS R package.")
  }