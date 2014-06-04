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
#' @return vector of upfront values (with accrual) in the same order

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
  
  ## change expiries depending on currency
  ## feeding in expiries, types (and rates) instead of extracting from getRates saves time as
  ## getRates would download the data from the internet
  if(currency=="USD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y",
                 "10Y", "12Y", "15Y", "20Y", "25Y", "30Y")
    types = "MMMMMSSSSSSSSSSSSSS"
    mmDCC = "ACT/360" 
    fixedSwapFreq = "6M" 
    floatSwapFreq = "3M"
    fixedSwapDCC = "30/360" 
    floatSwapDCC = "ACT/360" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="EUR"){
    expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", 
                 "5Y", "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", 
                 "30Y")
    types = "MMMMMSSSSSSSSSSSSSS"
    mmDCC = "ACT/360" 
    fixedSwapFreq = "1Y" 
    floatSwapFreq = "6M"
    fixedSwapDCC = "30/360" 
    floatSwapDCC = "ACT/360" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="GBP"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "25Y", 
                 "30Y")
    types = "MMMMMMSSSSSSSSSSSSSS"
    mmDCC = "ACT/365" 
    fixedSwapFreq = "6M" 
    floatSwapFreq = "6M"
    fixedSwapDCC = "ACT/365" 
    floatSwapDCC = "ACT/365" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="JPY"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "30Y")
    types = "MMMMMSSSSSSSSSSSSS"
    mmDCC = "ACT/360" 
    fixedSwapFreq = "6M" 
    floatSwapFreq = "6M"
    fixedSwapDCC = "ACT/365" 
    floatSwapDCC = "ACT/360" 
    badDayConvZC = "M" 
    holidays = "TYO"
    calendar = "TYO"
  } else if(currency=="CHF"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "25Y", 
                 "30Y")
    types = "MMMMMMSSSSSSSSSSSSSS"
    mmDCC = "ACT/360" 
    fixedSwapFreq = "1Y" 
    floatSwapFreq = "6M"
    fixedSwapDCC = "30/360" 
    floatSwapDCC = "ACT/360" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="CAD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "15Y", "20Y", "30Y")
    types = "MMMMMSSSSSSSSSSSS"
    mmDCC = "ACT/365" 
    fixedSwapFreq = "6M" 
    floatSwapFreq = "3M"
    fixedSwapDCC = "ACT/365" 
    floatSwapDCC = "ACT/365" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="AUD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "6Y", "7Y", "8Y", "9Y", "10Y", "15Y", "20Y", "30Y")
    types = "MMMMSSSSSSSSSSSS"
    mmDCC = "ACT/365" 
    fixedSwapFreq = "6M" 
    floatSwapFreq = "6M"
    fixedSwapDCC = "ACT/365" 
    floatSwapDCC = "ACT/365" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="NZD"){
    expiries = c("1M", "2Y", "3Y", "6Y", "4Y", "5Y",
                 "7Y", "10Y", "15Y")
    types = "MMMMSSSSS"
    mmmDCC = "ACT/365" 
    fixedSwapFreq = "6M" 
    floatSwapFreq = "6M"
    fixedSwapDCC = "ACT/365" 
    floatSwapDCC = "ACT/365" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="SGD"){
    expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", 
                 "5Y", "6Y", "7Y", "10Y", "12Y", "15Y", "20Y")
    types = "MMMMMMSSSSSSSSSS"
    mmDCC = "ACT/365" 
    fixedSwapFreq = "6M" 
    floatSwapFreq = "6M"
    fixedSwapDCC = "ACT/365" 
    floatSwapDCC = "ACT/365" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  } else if(currency=="HKD"){
    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                 "7Y", "10Y", "12Y", "15Y")
    types = "MMMMMSSSSSSSS"
    mmDCC = "ACT/365" 
    fixedSwapFreq = "3M" 
    floatSwapFreq = "3M"
    fixedSwapDCC = "ACT/365" 
    floatSwapDCC = "ACT/365" 
    badDayConvZC = "M" 
    holidays = "None"
    calendar = "None"
  }
  
  results <- NULL
  
  for(i in 1:nrow(x)){    
    results <- c(results, 
                 upfront(TDate = x[i, date.var],
                         currency = currency,                    
                         types = types,
                         rates = rates[rates$date == as.Date(x[i, date.var]), c("rates")],
                         expiries = expiries,                    
                         mmDCC = as.character(mmDCC),                    
                         fixedSwapFreq = as.character(fixedSwapFreq),
                         floatSwapFreq = as.character(floatSwapFreq),
                         fixedSwapDCC = as.character(fixedSwapDCC),
                         floatSwapDCC = as.character(floatSwapDCC),
                         badDayConvZC = as.character(badDayConvZC),
                         holidays = as.character(holidays),                   
                         maturity = x[i, maturity.var],                    
                         parSpread = x[i, spread.var],
                         coupon = x[i, coupon.var],
                         recoveryRate = 0.4,
                         isPriceClean = FALSE,
                         calendar = calendar,
                         notional = notional))
  }  
  return(results)
}