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
#' @examples
#' \dontrun{
#' build.rates(start = as.Date("2004-01-01"), end = as.Date("2014-08-23"))
#' }

build.rates <- function(start = as.Date("2004-01-01"), 
                        end = as.Date("2005-01-04")){
  
  ## Don't run the example of this function, since it will take more than
  ## two hours. It is always wiser for user who needs most recent data
  ## to just rbind() the ready rates.RData with the newly get data
  
  ## First, understand the limits of markit: for USD, markit can get
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
  ## expiry over 1Y.
  
  ## So we hardcoded the dates below, to combine markit and FRED in the
  ## most suitable way. First, markit gets USD rates.
  
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
  
  ## sort the data as required: currently descending date and ascending 
  ## currency, and ascending expiry. Notice that do not try to sort
  ## expiry here, since download.markit and download.FRED have already
  ## ensured that their outputs' expiry is in ascending form.
  
  x <- x[order(x$date, rev(x$currency), decreasing = FALSE), ]
  
  return(x)
}