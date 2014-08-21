#' Get rates for a continuous period
#' 
#' \code{get.rates.DF} takes a data frame of dates and returns a data frame with
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

get.rates.DF <- function(start, end, currency = "USD"){
  
  stopifnot(inherits(start, "Date"))
  stopifnot(inherits(end, "Date"))
  
  ## start date must be smaller than end date
  
  stopifnot(end > start)
  
  ## Our loop will just append to x each time through.
  
  x <- NULL
  
  while(end > start){
    
    ## use get.rates with the end date and keep reducing it by 1 day
    ## store this data in Rates
    
    Rates <- try(get.rates(date = end, currency=currency)[[1]])
    
    ## we use try so that if there is a date where rates are unavailable,
    ## it doesn't stop the function. 
    
    if(is(Rates, "try-error")){
      end <- end - 1 
    } else {
      getRates <- Rates
      
      ## extract relevant columns from Rates
      
      rate <- as.numeric(as.character(getRates$rate))
      expiry <- getRates$expiry
      date <- rep(end, length(rate))
      
      ## append all the data from the different dates where rates are available
      
      x <- rbind(x, data.frame(date, currency, expiry, rate))
      end <- end - 1      
    }    
  }  
  
  x$expiry <- as.character(x$expiry)
  
  return(x)
}