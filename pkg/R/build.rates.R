#' Build rates.RData
#' 
#' \code{build.rates} builds the rates.RData stored in the package. The
#' usage of rates.RData is explained in the rates.Rd help file. Please
#' type ?rates to see it.
#'
#' @param start is the start date of the data frame; it is the earliest day
#'        of interest rate that we want in the data frame
#' @param end is the end date of the data frame; it is the lastest day
#'        of interest rate that we want in the data frame
#' 
#' @return a data frame that contains the rates based on the ISDA 
#'         pecifications
#'
#' @export
#' 
#' @seealso \link{download.markit} \link{download.FRED} \link{rates}
#' 
#' @examples
#' \dontrun{
#' build.rates(start = as.Date("2004-01-01"), end = as.Date("2014-08-23"))
#' }

build.rates <- function(start = as.Date("2004-01-01"), 
                        end = as.Date("2005-01-04")){
  
  ## Don't run the example of this function, since it will take more than
  ## two hours
  
  stopifnot(inherits(start, "Date") & inherits(end, "Date"))
  
  ## First, know some basics: for USD, markit can get
  ## whatever it wants, from 2000 to now; for EUR and JPY, markit can
  ## only get from 2005-01-05 to now. But the biggest advantage of 
  ## markit is that it knows the type of expiries to choose for different
  ## currencies in different time. Also, it has expiry over 1Y to 30Y.
  ## Then understand FRED: FRED is complementary to markit data. Since
  ## markit can get any rates for USD, we don't use FRED for USD. Then
  ## we want to get data for EUR and JPY before 2005-01-01 (the limit of
  ## markit). FRED has almost all data for any date, which is its biggest
  ## advantage. But its biggest disadvantage is that it doesn't know
  ## which expiry type is suitable for which time; also it doesn't have
  ## expiry over 1Y.So we hardcoded the dates below, to combine markit
  ## and FRED in the most suitable way. 
  
  ## another note is that, the rates on both markit and FRED have not been
  ## adjusted to the previous business day. In other words, the rates from
  ## both website is the exact rate on that day, rather than on the previous
  ## business day. But download.markit and download.FRED have adjusted
  ## the days already, so we don't have to worry here.
  
  ## If start date is before and end date is after 2005-01-05,
  ## then we have to use markit for USD, and both markit and FRED for
  ## JPY and EUR
  
  if(start < as.Date("2005-01-05") & end >= as.Date("2005-01-05")){
    
    ## First, markit gets USD rates.
    
    x.markit.USD <- download.markit(start = start, end = end, currency = "USD")
    
    ## Then markit gets rate for EUR and JPY after 2005-01-05
    
    x.markit.EUR <- download.markit(start = as.Date("2005-01-05"), 
                                    end = end, currency = "EUR")
    x.markit.JPY <- download.markit(start = as.Date("2005-01-05"), 
                                    end = end, currency = "JPY")
    
    ## Then FRED gets data for EUR and JPY before 2005-01-04; the default
    ## expiry type is 1M, 2M, 3M, 6M, 1Y (or 12M on FRED)
    
    x.FRED.EUR   <- download.FRED(start = start, end = as.Date("2005-01-04"), 
                                  currency = "EUR")
    x.FRED.JPY   <- download.FRED(start = start, end = as.Date("2005-01-04"), 
                                  currency = "JPY")
    
    ## bind the data together
    
    x <- rbind(x.markit.USD, x.FRED.EUR, 
               x.markit.EUR, x.FRED.JPY, x.markit.JPY)
  } 
  
  ## If start date  and end date are after 2005-01-05,
  ## then we only have to use markit
  
  else if(start >= as.Date("2005-01-05")){
    x.markit.USD <- download.markit(start = start, end = end, currency = "USD")
    x.markit.EUR <- download.markit(start = start, end = end, currency = "EUR")
    x.markit.JPY <- download.markit(start = start, end = end, currency = "JPY")
    x <- rbind(x.markit.USD, x.markit.EUR, x.markit.JPY)
  } 
  
  ## If start date  and end date are before 2005-01-05,
  ## then we have to use markit for USD and only FRED for EUR and JPY
  
  else if(end < as.Date("2005-01-05")){
    x.markit.USD <- download.markit(start = start, end = end, currency = "USD")
    x.FRED.EUR   <- download.FRED(start = start, end = end, currency = "EUR")
    x.FRED.JPY   <- download.FRED(start = start, end = end, currency = "JPY")  
    x <- rbind(x.markit.USD, x.FRED.EUR, x.FRED.JPY)
  } 
  
  ## sort the data as required: currently ascending date and ascending currency.
  ## Ought to sort by ascending expiry, but that is harder than it looks.
  
  x <- x[order(x$date, x$currency, decreasing = FALSE), ]
  
  return(x)
}