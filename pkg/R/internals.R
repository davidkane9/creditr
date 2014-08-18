#' Internal Functions
#' 
#' download the rates zip file from a given URL. Unzip and parse the
#' XML
#'
#' @param URL is the link containing the rates.
#' @param verbose option. Default \code{FALSE}.
#'
#' @return a xml file crawled from the \code{URL}.
#' 

.download.rates <- function(URL, verbose = FALSE){ 
  tf <- tempfile()
  td <- tempdir()
  
  f <- CFILE(tf, mode="wb")
  a <- tryCatch(curlPerform(url = URL,
                            writedata = f@ref, noprogress=TRUE,
                            verbose = FALSE,
                            ssl.verifypeer = FALSE),
                error = function(e) {
                  return("Rates data not available at markit.com")
                })
  close(f)
  if (class(a) == "character"){
    return(a)
  } else {
    files <- unzip(tf , exdir = td)
    
    ## the 2nd file of the unzipped directory contains the rates info
    
    doc <- xmlTreeParse(files[grep(".xml", files)], getDTD = F)
    r <- xmlRoot(doc)
    return(r)
  }
}

#' Get the first accrual date. If it's a weekend, adjust to the
#' following weekday. March/Jun/Sept/Dec 20th
#'
#' @param TDate of \code{Date} class
#' @return a \code{Date} class object

.get.first.accrual.date <- function(TDate){
  
  date <- as.POSIXlt(TDate)
  
  ## get the remainder X after dividing it by 3 and then move back X month
  
  if (date$mon %in% c(2, 5, 8, 11)){
    if (date$mday < 20)
      date$mon <- date$mon - 3
  } else { 
    date$mon <- date$mon - (as.numeric(format(date, "%m")) %% 3)
  }
  date$mday <- 20
  accrualDate <- adj.next.bus.day(as.Date(as.POSIXct(date)))
  
  return(accrualDate)
}

#.onAttach <- function(...) {
  
 # packageStartupMessage(
  #  "\nIF YOU USE THIS CDS PACKAGE, YOUR USE WILL SIGNIFY YOUR UNDERSTANDING \nAND IRREVOCABLE ACCEPTANCE OF THIS LICENSE AND ITS TERMS, WHICH INCORPORATE \nBY REFERENCE THE INTERNATIONAL SWAPS AND DERIVATIVES ASSOCIATION, INC.'S CDS \nSTANDARD MODEL PUBLIC LICENSE, WHICH IS AVAILABLE AT \nhttp://www.cdsmodel.com/cdsmodel/cds-disclaimer.page before using the package. \n\nNOTHING IN THIS LICENSE RESTRICTS YOUR ABILITY TO USE THE ISDA(R) CDS \nSTANDARD MODEL.\n \nDISCLAIMER: ISDA HAS NEITHER REVIEWED, APPROVED NOR ENDORSED THE USE OF \nTHE CDS PACKAGE. THOSE PERSONS USING THIS CDS PACKAGE ARE ENCOURAGED TO SEEK \nTHE ADVICE OF A LEGAL PROFESSIONAL TO EVALUATE ITS SUITABILITY FOR THEIR USE.\n \nISDA(R) is a registered mark of the International Swaps and Derivatives \nAssociation, Inc.\n \nPlease type **yes** to assent to the aforementioned terms.\n")
  
  #if(interactive()){
   # while (readLines(n=1)!="yes")
    #  packageStartupMessage("Please type **yes** to assent to the aforementioned terms.\n")
  #}
#}
