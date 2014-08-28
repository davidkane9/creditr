#' Build a data frame containing interest rates for CDS pricing
#' 
#' \code{build.rates} can create a data frame of interest rates from a start 
#' date to an end date, which are specified by the user. The interest rates will
#' be later used in CDS pricing. \code{build.rates} also builds the rates.RData 
#' in the package. \code{build.rates} mainly consists \code{download.markit} and
#' \code{download.FRED}. The two sources are Markit website and FRED website.
#' 
#' @param start.date is the start date of the data frame; it is the earliest CDS
#'   pricing date that the user concerns.
#' @param end.date is the end date of the data frame; it is the lastest CDS 
#'   pricing date that the user concerns.
#'   
#' @return a data frame that contains the CDS pricing date, the currency, the 
#'   interest rate expiry and the interest rate.
#'   
#' @details
#' since Markit wesite has the interest rates back to th 1990s, download.markit
#' is responsible for building up all the USD interest rate data frame; for EUR
#' and JPY, markit can only get from 2005-01-05 to now. But the biggest
#' advantage of using download.markit is that, since Markit website only lists
#' the rate expiries that are actually used for CDS pricing, download.markit can
#' get the exact type of expiries of rates needed to price CDS. Also, it has
#' expiry over 1Y to 30Y. In contrast, FRED is only complementary to markit
#' data. Since download.markit can get any rates for USD, we don't use FRED for
#' USD. Then we want to get data for EUR and JPY before 2005-01-04 (the limit of
#' markit). FRED has almost all data for any date, which is its biggest 
#' advantage. But its biggest disadvantage is that it doesn't know which expiry
#' type is suitable for which time, since FRED website has expiry of all types
#' below a year; also it doesn't have expiry over 1Y.So we hardcoded the dates
#' below, to combine markit and FRED in the most suitable way.
#' 
#' Another note is that, the rates on both Markit website and FRED website have
#' not been adjusted to the previous business day. In other words, the rates
#' from both website is the exact rate on that day, rather than on the previous 
#' business day. But download.markit and download.FRED have adjusted the days
#' already for the convenience of CDS pricing, so we don't have to worry here.
#' 
#' @seealso \link{download.markit} \link{download.FRED} \link{rates}
#'   
#' @references \url{http://www.markit.com/} 
#'   \url{http://research.stlouisfed.org/fred2/categories/33003/downloaddata}
#'   
#' @examples
#' \dontrun{
#' ## Running this example will take more than two hours.
#' 
#' build.rates(start.date = as.Date("2004-01-01"), 
#'             end.date = as.Date("2014-08-23"))}

build.rates <- function(start.date = as.Date("2004-01-01"), 
                        end.date = as.Date("2005-01-04")){
  
  ## Don't run the example of this function, since it will take more than two
  ## hours
  
  stopifnot(inherits(start, "Date") & inherits(end, "Date"))
  
  ## First, know some basics: since Markit wesite has the interest rates back to
  ## th 1990s, download.markit is responsible for building up all the USD
  ## interest rate data frame; for EUR and JPY, markit can only get from
  ## 2005-01-05 to now. But the biggest advantage of using download.markit is
  ## that, since Markit website only lists the rate expiries that are actually 
  ## used for CDS pricing, download.markit can get the exact type of expiries of
  ## rates needed to price CDS. Also, it has expiry over 1Y to 30Y. In contrast,
  ## FRED is only complementary to markit data. Since download.markit can get
  ## any rates for USD, we don't use FRED for USD. Then we want to get data for
  ## EUR and JPY before 2005-01-04 (the limit of markit). FRED has almost all
  ## data for any date, which is its biggest advantage. But its biggest
  ## disadvantage is that it doesn't know which expiry type is suitable for
  ## which time, since FRED website has expiry of all types below a year; also
  ## it doesn't have expiry over 1Y.So we hardcoded the dates below, to combine
  ## markit and FRED in the most suitable way.
  
  ## another note is that, the rates on both Markit website and FRED website
  ## have not been adjusted to the previous business day. In other words, the
  ## rates from both website is the exact rate on that day, rather than on the
  ## previous business day. But download.markit and download.FRED have adjusted 
  ## the days already for the convenience of CDS pricing, so we don't have to
  ## worry here.
  
  ## If start date is before and end date is after 2005-01-05,
  ## then we have to use markit for USD, and both markit and FRED for
  ## JPY and EUR
  
  if(start.date < as.Date("2005-01-05") & end.date >= as.Date("2005-01-05")){
    
    ## First, markit gets USD rates.
    
    x.markit.USD <- download.markit(start = start.date, end = end.date, 
                                    currency = "USD")
    
    ## Then markit gets rate for EUR and JPY after 2005-01-05
    
    x.markit.EUR <- download.markit(start = as.Date("2005-01-05"), 
                                    end = end.date, currency = "EUR")
    x.markit.JPY <- download.markit(start = as.Date("2005-01-05"), 
                                    end = end.date, currency = "JPY")
    
    ## Then FRED gets data for EUR and JPY before 2005-01-04; the default expiry
    ## type is 1M, 2M, 3M, 6M, 1Y (or 12M on FRED)
    
    x.FRED.EUR   <- download.FRED(start = start.date, end = as.Date("2005-01-04"), 
                                  currency = "EUR")
    x.FRED.JPY   <- download.FRED(start = start.date, end = as.Date("2005-01-04"), 
                                  currency = "JPY")
    
    ## bind the data together
    
    x <- rbind(x.markit.USD, x.FRED.EUR, 
               x.markit.EUR, x.FRED.JPY, x.markit.JPY)
  } 
  
  ## If start date  and end date are after 2005-01-05, then we only have to use
  ## markit
  
  else if(start.date >= as.Date("2005-01-05")){
    x.markit.USD <- download.markit(start = start.date, end = end.date, 
                                    currency = "USD")
    x.markit.EUR <- download.markit(start = start.date, end = end.date, 
                                    currency = "EUR")
    x.markit.JPY <- download.markit(start = start.date, end = end.date, 
                                    currency = "JPY")
    x <- rbind(x.markit.USD, x.markit.EUR, x.markit.JPY)
  } 
  
  ## If start date  and end date are before 2005-01-05, then we have to use
  ## markit for USD and only FRED for EUR and JPY
  
  else if(end < as.Date("2005-01-05")){
    x.markit.USD <- download.markit(start = start.date, end = end.date, 
                                    currency = "USD")
    x.FRED.EUR   <- download.FRED(start = start.date, end = end.date, 
                                  currency = "EUR")
    x.FRED.JPY   <- download.FRED(start = start.date, end = end.date, 
                                  currency = "JPY")  
    x <- rbind(x.markit.USD, x.FRED.EUR, x.FRED.JPY)
  } 
  
  ## sort the data as required: currently ascending date and ascending currency.
  ## Ought to sort by ascending expiry, but that is harder than it looks.
  
  x <- x[order(x$date, x$currency, decreasing = FALSE), ]
  
  return(x)
}