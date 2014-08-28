#' Get Rates
#' 
#' \code{get.rates} returns the deposits and swap rates for the day
#' input, along with the date conventions for that specific currency. 
#' The day input should be a weekday. If not, go to the most
#' recent previous weekday.
#'
#' @param date Trade date. The rates for a trade date T are
#' published on T-1 weekday. This date refers to the day on which we
#' want the CDS to be priced, not the date for the interest rates as
#' the interest rates will be used is the day before the trade date. Eg.
#' If we are trying to find the rates used to price a CDS on 2014-04-22,
#' it will return the rates of 2014-04-21
#' @param currency the three-letter currency code. As of now, it works
#' for USD, EUR, and JPY. The default is USD.
#' 
#' @return a list with two data frames. The first data frame contains
#' the rates based on the ISDA specifications; the second contains all
#' the dcc and calendar specifications of the curve.
#'
#' @examples
#' \dontrun{
#' get.rates(as.Date("2014-05-07"), currency = "USD")
#' }

get.rates <- function(date = Sys.Date(), currency = "USD"){

    ## coerce into character and change to upper case
  
    stopifnot(toupper(as.character(currency)) %in% 
    c( "USD", "GBP", "EUR", "JPY", "CHF", "CAD" , "AUD", "NZD", "SGD", "HKD"))

    ## check rates.RData first, before get rates from the internet.
    
    date <- as.Date(date)
    
    data(rates)
    ratesx <- rates[which(rates$date == date),]
    ratesx <- ratesx[which(ratesx$currency == currency),]
    ratesx <- data.frame(expiry = as.character(ratesx$expiry),
                         rate = ratesx$rate,
                         type = as.character(substr(ratesx$expiry, start = nchar(ratesx$expiry), 
                                        stop = nchar(ratesx$expiry))),
                         stringsAsFactors = FALSE)
    
    if(nrow(ratesx) != 0){
    for(k in 1:length(ratesx$type)){
      if(ratesx$type[k] == "Y") ratesx$type[k] <- "S"
    }
    
    ratesx$type[which(ratesx$expiry == "1Y")] <- "M"
    }
    
    ## if the wanted rates are not in rates.RData, then go get rates
    ## from the internet
    
    if(nrow(ratesx) == 0){
      
      ## CDS for Trade Date will use rates from Trade Date - 1 
      
      date <- as.Date(date) - 1
      
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
                           rate = substring(x[,2], 11),
                           
                           ## if maturity is 1Y, it is of type M
                           
                           type = c(rep("M", sum(names(rates$deposits) == "curvepoint")),
                                    rep("S", sum(names(rates$swaps) == "curvepoint"))))
      
      ratesx$expiry <- as.character(ratesx$expiry)
    }
    return(ratesx)
}
