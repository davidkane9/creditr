#' Get rates from Markit
#' 
#' \code{download.markit} takes a data frame of dates and returns a data frame with
#' the yields for different maturities. Note year must be entered as YYYY-MM-DD.
#' 
#' @param start date for gathering interest rates. Must be a Date type
#' @param end date for gathering interest rates. Must be a Date type
#' @param currency for which rates are being retrieved
#' 
#' @return data frame containing the rates from every day from start to end 
#'   dates. Note: the date in the output data frame does not refer to the rates 
#'   of that day but to the date on which the CDS is being priced. So the 
#'   corresponding rate is actually the rate of the previous day. Example: if 
#'   the column reads 2014-04-22, the corresponding rates are actually for 
#'   2014-04-21.
#'   
#' @examples
#' \dontrun{
#' download.markit(start = as.Date("2005-12-31"), end = as.Date("2006-01-04"), 
#'               currency = "JPY")
#' }       

download.markit <- function(start, end, currency = "USD"){
  
  stopifnot(inherits(start, "Date"))
  stopifnot(inherits(end, "Date"))
  
  ## start date must be smaller than end date
  
  stopifnot(end > start)
  
  ## Our loop will just append to x each time through.
  
  x <- NULL
  
  ## we let start date go back one day so that we get previous day's rate
  
  start <- start - 1
  
  ## We put download.rates() and oneday.markit() here for convenience, it
  ## will be better if we can get rid of these two functions totally and 
  ## just leave download.markit() as the only function. But I tries and
  ## it seems pretty hard to get rid of them, especially download.rates(),
  ## whose absence can cause R CMD Check to fail. So I suggest leave them
  ## for now, and wait until other functions are furnished.
  
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
  
  ## another internal function
  
  oneday.markit <- function(date = Sys.Date(), currency = "USD"){
    
    ## coerce into character and change to upper case
    
    stopifnot(toupper(as.character(currency)) %in% 
                c( "USD", "GBP", "EUR", "JPY", "CHF", "CAD" , "AUD", "NZD", "SGD", "HKD"))
    
    #stopifnot(is.character(currency))
    
    ## CDS for Trade Date will use rates from Trade Date - 1 
    
    date <- as.Date(date) - 1
    
    ## 0 is Sunday, 6 is Saturday
    
    dateWday <- as.POSIXlt(date)$wday
    
    ## change date to the most recent weekday if necessary i.e. change date to 
    ## Friday if the day we are pricing CDSs is Saturday or Sunday
    
    if (dateWday == 0){
      date <- date - 2
    } else if (dateWday == 6) {
      date <- date - 1
    }
    
    ## convert date to numeric
    
    dateInt <- format(date, "%Y%m%d")
    
    ## markit rates URL
    
    ratesURL <- paste("https://www.markit.com/news/InterestRates_",
                      currency, "_", dateInt, ".zip", sep ="")
    
    ## XML file from the internet, which contains the rates data
    
    xmlParsedIn <- download.rates(ratesURL)
    
    ## rates data extracted from XML file
    
    rates <- xmlSApply(xmlParsedIn, function(x) xmlSApply(x, xmlValue))
    
    ## extracts the 'M' or 'Y' of the expiry and stores it in curveRates
    
    curveRates <- c(rates$deposits[names(rates$deposits) == "curvepoint"],
                    rates$swaps[names(rates$swaps) == "curvepoint"])
    
    ## split the numbers from the 'M' and 'Y'
    
    x <- do.call(rbind, strsplit(curveRates, split = "[MY]", perl = TRUE))
    rownames(x) <- NULL
    x <- cbind(x, "Y")
    
    ## attacg M to money month rates
    
    x[1: (max(which(x[,1] == 1)) - 1), 3] <- "M"
    
    ## data frame with Interest Rates, maturity, type, expiry
    
    ratesx <- data.frame(expiry = paste(x[,1], x[,3], sep = ""),
                         matureDate = substring(x[,2], 0, 10),
                         rate = substring(x[,2], 11),
                         
                         ## if maturity is 1Y, it is of type M
                         
                         type = c(rep("M", sum(names(rates$deposits) == "curvepoint")),
                                  rep("S", sum(names(rates$swaps) == "curvepoint"))))
    
    ratesx$expiry <- as.character(ratesx$expiry)
    
    return(ratesx)
  }
  
  ## Here begins the formal main body of download.markit()
  
  while(end > start){
    
    ## use get.rates with the end date and keep reducing it by 1 day
    ## store this data in Rates
    
    Rates <- try(oneday.markit(date = end, currency=currency))
    
    ## we use try so that if there is a date where rates are unavailable,
    ## it doesn't stop the function. 
    
    if(is(Rates, "try-error")){
      end <- end - 1 
    } else {
      
      ## append all the data from the different dates where rates are available
      
      x <- rbind(x, data.frame(date = rep(end, length(as.numeric(as.character(Rates$rate)))),
                               currency = currency,
                               expiry = Rates$expiry,
                               rate = as.numeric(as.character(Rates$rate))))
      
      end <- end - 1      
    }    
  }
  
  ## convert factor type to character
  
  x$currency = as.character(x$currency)
  x$expiry = as.character(x$expiry)
  
  ## convert data frame to xts object; use hte first column of the data 
  ## frame as the time index of the xts object
  
  x.xts <- xts(x[, -1], order.by = x[, 1])
  
  ## Here we use "xts" package because it is good at manipulating missing
  ## dates. We define here an empty zoo object for the merge() later.
  
  empty <- zoo(order.by = seq.Date(head(index(x.xts), 1), 
                                   tail(index(x.xts), 1), by = "days"))
  
  ## merge() is a cool command that can merge two zoo objects together.
  ## Whenever merge() finds a missing row of date in raw.data, it will use the 
  ## previous day's rate to fill the blank of the empty row of date in
  ## the empty zoo object. This just satisfies our need, because according
  ## to ISDA Standard Model, we use previous business day's rate for
  ## holidays and weekends. And this is exactly carried out by merge()
  ## and na.locf(). For further explanation, see stackoverflow.
  
  data <- suppressWarnings(na.locf(merge(x.xts, empty)))
  
  ## convert xts object to data frame; use time index of xts object as the
  ## first date column of the data frame
  
  x <- data.frame(date = index(x.xts), coredata(x.xts))
  
  ## convert factor type to character or numeric type
  ## Notice that converting factor type to a numeric type is a little bit
  ## more tedious, cuz if you directly use as.numeric(x$rate) some 
  ## information may be lost (see ?factor); so convert its factor level
  ## is more correct
  
  x$currency <- as.character(x$currency)
  x$expiry   <- as.character(x$expiry)
  x$rate     <- as.numeric(levels(x$rate))[x$rate]
  
  return(x)
}