#' \code{download.rates} download the rates zip file from a given URL. Unzip and parse the
#' XML
#' 
#' @param URL is the link containing the rates.
#' @param verbose option. Default \code{FALSE}.
#' 
#' @return a xml file crawled from the \code{URL}.
#' 
download.rates <- function(URL, verbose = FALSE){ 
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
    return(xmlRoot(doc))
  }
}

