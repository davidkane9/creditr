#' Function that takes a dataframe of variables on CDSs to return a vector
#' of upfront values
#' 
#' @param x dataframe containing variables date, spread, coupon and maturity
#' @param rates dataframe containing dates and rates for those dates
#' @param currency of CDSs in the dataframe. By default is USD.
#' @param notional values of CDSs in the dataframe,. By defualt is 10 million 
#' @param date.var name of the column containing dates. By default is "date"
#' @param spread.var name of the column containing spreads. By default is "spread".
#' @param coupon.var name of the column containing the coupon rates. By default is
#' "coupon"
#' @param maturity.var name of the column containing the maturity dates (note: this
#' is different from tenor i.e. it is a proper date like "2019-06-20" and not "5Y").
#' By default is "maturity"/
#' 
#' @return vector of upfront values in the same order

upfrontdf <- function(x, 
                      rates, 
                      currency = "USD", 
                      notional = 1e7,
                      date.var = "date", 
                      spread.var = "spread",
                      coupon.var = "coupon", 
                      maturity.var = "maturity"){
    
  stopifnot(all(c(date.var, spread.var, coupon.var, maturity.var) %in% names(x)))
  stopifnot(inherits(as.Date(x[[date.var]]), "Date"))
  stopifnot(inherits(as.Date(x[[maturity.var]]), "Date"))
  ## stop if the relevant variables are not of the appropriate type 
  stopifnot(is.numeric(notional))
  stopifnot(is.character(currency))
  stopifnot(is.numeric(x[[coupon.var]]))
  ## stop if one of the dates in the X data frame does not have a corresponding
  ## interest rate curve in the rates data frame.
  stopifnot(!(FALSE %in% check.Rates.Dates(x, rates)))  
  
  if(currency=="USD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y",
                 "25Y", "30Y")                      
  } else if(currency=="EUR"){
    expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", 
                 "5Y", "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", 
                 "30Y")                        
  } else if(currency=="GBP"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "25Y", 
                 "30Y")                        
  } else if(currency=="JPY"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "30Y")                        
  } else if(currency=="CHF"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "25Y", 
                 "30Y")
  } else if(currency=="CAD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "15Y", "20Y", "30Y")
  } else if(currency=="AUD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "15Y", "20Y", "30Y")
  } else if(currency=="NZD"){
    expiries = c("1M", "2Y", "3Y", "6Y", "4Y", "5Y",
                 "7Y", "10Y", "15Y")
  } else if(currency=="SGD"){
    expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", 
                 "5Y", "6Y", "7Y", "10Y", "12Y", "15Y", "20Y")
  } else if(currency=="HKD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "7Y", "10Y", "12Y", "15Y")
  }
  
  results <- NULL
  
  for(i in 1:nrow(x)){    
    results <- c(results, 
                 upfront( currency = currency,
                          TDate = x[i, date.var],
                          maturity = x[i, maturity.var],
                          rates = rates[rates$date == as.Date(x[i, date.var]), c("rates")],
                          expiries = expiries,
                          parSpread = x[i, spread.var],
                          coupon = x[i, coupon.var],
                          recoveryRate = 0.4,
                          isPriceClean = FALSE,
                          notional = notional))
  }  
  return(results)
}