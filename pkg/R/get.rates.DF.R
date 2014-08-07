#' \code{get.rates.DF} takes a data frame of dates and returns a data frame with
#' the yields for different maturities. Note year must be entered as YYYY-MM-DD.
#' 
#' @param start date for gathering interest rates
#' @param end date for gathering interest rates
#' @param currency for which rates are being retrieved
#' @return data frame containing the rates from every day from start to end 
#'   dates. Note: the date in the output data frame does not refer to the rates 
#'   of that day but to the date on which the CDS is being priced. So the 
#'   corresponding rate is actually the rate of the previous day. Example: if 
#'   the column reads 2014-04-22, the corresponding rates are actually for 
#'   2014-04-21.
 
get.rates.DF <- function(start, end, currency = "USD"){

  stopifnot(inherits(start, "Date"))
  stopifnot(inherits(end, "Date"))

  ## start & end date must be valid
  
  stopifnot(check.date(start))
  stopifnot(check.date(end))
    
  ## start date must be smaller than end date
  
  stopifnot(end > start)
  
  ## Our loop will just append to x each time through.
  
  x <- NULL
  
  while(end > start){
    Rates <- try(get.rates(date = end, currency=currency)[[1]])
    if(is(Rates, "try-error")){
      getRates <- NULL
      end <- end - 1 
    } else {
      getRates <- Rates
      rates <- as.numeric(as.character(getRates$rate))
      expiry <- getRates$expiry
      date <- rep(end, length(rates))
      thisCurrency <- rep(currency, length(rates))
      df <- data.frame(date, currency, expiry, rates)
      x <- rbind(x, df)
      end <- end - 1      
    }    
  }  
  
  return(x)
}
