#' \code{upfrontdf} takes a dataframe of variables on CDSs to return a vector of
#' upfront values. Note that all CDS in the data frame must be denominated in 
#' the same currency.
#' 
#' @param x dataframe containing variables date.var, spread.var, coupon.var and
#'   maturity.var.
#' @param rates dataframe containing dates and rates for those dates. Note that 
#'   the date column over here refers to the date for which the adjacent 
#'   interest rate curve would apply. So if it says "2014-07-25", the interest 
#'   rate curve is from "2014-07-24".
#' @param currency.var name of the column for currencies in the dataframe. 
#' @param notional values of CDSs in the dataframe. Defualt is 10 million.
#' @param date.var name of the column containing dates. By default is "date"
#' @param spread.var name of the column containing spreads. By default is 
#' "spread".
#' @param coupon.var name of the column containing the coupon rates. By default 
#' is "coupon"
#' @param maturity.var name of the column containing the maturity dates (note: 
#' this is different from tenor i.e. it is a proper date like "2019-06-20" and
#' not "5Y"). By default is "maturity".
#' @param tenor.var name of the column containing the tenors of the CDS contracts.
#' Note that we can only provide either the tenor or the maturity date, not both.    
#' @param isPriceClean boolean to specify if you want the dirty upfront or the 
#' clean upfront (principal).
#'   
#' @return vector of upfront values (with accrual) in the same order

upfrontdf <- function(x, 
                      rates, 
                      currency.var = "currency", 
                      notional = 1e7,
                      date.var = "date", 
                      spread.var = "spread",
                      coupon.var = "coupon",
                      tenor.var = "tenor",
                      maturity.var = "maturity",
                      isPriceClean = FALSE){
  
  
  ## You must provide either a maturity or a tenor, but not both.
  
  stopifnot(! (is.null(x[[maturity.var]]) & is.null(x[[tenor.var]]))) ## stop if both are null
  stopifnot(   is.null(x[[maturity.var]]) | is.null(x[[tenor.var]])) ## stop if neither of them are NULL
  
  ## stop if not the relevant variables are not contained in x
  
  stopifnot(all(c(date.var, spread.var, coupon.var) %in% names(x)))
  
  ## stop if the relevant variables are not of the appropriate type 
  
  stopifnot(inherits(as.Date(x[[date.var]]), "Date"))
  if(!is.null(x[[maturity.var]])){
    stopifnot(inherits(as.Date(x[[maturity.var]]), "Date"))
  }
  stopifnot(inherits(as.character(x[[currency.var]]), "character"))
  stopifnot(is.numeric(notional))
  stopifnot(is.numeric(x[[coupon.var]]))
  
  ## stop if one of the dates in the X data frame does not have a corresponding
  ## interest rate curve in the rates data frame.
  
  stopifnot(!(FALSE %in% check.Rates.Dates(x, rates)))  
  
  ## subset out the rates data frame to only include the dates between the oldest and
  ## latest date in the 'x' data frame.
  
  min.date <- min(as.Date(x[[date.var]]))
  max.date <- max(as.Date(x[[date.var]]))
  
  rates <- rates[rates$date >= min.date & rates$date <= max.date,]
  
  results <- NULL
  
  for(i in 1:nrow(x)){
    
    ## subset out the rates of the relevant currency
        
    ## change expiries depending on currency
    ## feeding in expiries, types (and rates) instead of extracting from getRates saves time as
    ## getRates would download the data from the internet
    
    if(x[i, currency.var]=="USD"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y",
                   "10Y", "12Y", "15Y", "20Y", "25Y", "30Y")
      types <- "MMMMMSSSSSSSSSSSSSS"
      mmDCC <- "ACT/360" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "3M"
      fixedSwapDCC <- "30/360" 
      floatSwapDCC <- "ACT/360" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="EUR"){
      expiries <- c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", 
                   "5Y", "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", 
                   "30Y")
      types <- "MMMMMMSSSSSSSSSSSSS"
      mmDCC <- "ACT/360" 
      fixedSwapFreq <- "1Y" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "30/360" 
      floatSwapDCC <- "ACT/360" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="GBP"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                   "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "25Y", 
                   "30Y")
      types <- "MMMMMMSSSSSSSSSSSSSS"
      mmDCC <- "ACT/365" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/365" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="JPY"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                   "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "30Y")
      types <- "MMMMMSSSSSSSSSSSSS"
      mmDCC <- "ACT/360" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/360" 
      badDayConvZC <- "M" 
      holidays <- "TYO"
      calendar <- "TYO"
    } else if(x[i, currency.var]=="CHF"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                   "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "25Y", 
                   "30Y")
      types <- "MMMMMMSSSSSSSSSSSSSS"
      mmDCC <- "ACT/360" 
      fixedSwapFreq <- "1Y" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "30/360" 
      floatSwapDCC <- "ACT/360" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="CAD"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                   "6Y", "7Y", "8Y", "9Y", "10Y", "15Y", "20Y", "30Y")
      types <- "MMMMMSSSSSSSSSSSS"
      mmDCC <- "ACT/365" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "3M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/365" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="AUD"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                   "6Y", "7Y", "8Y", "9Y", "10Y", "15Y", "20Y", "30Y")
      types <- "MMMMSSSSSSSSSSSS"
      mmDCC <- "ACT/365" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/365" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="NZD"){
      expiries <- c("1M", "2Y", "3Y", "6Y", "4Y", "5Y",
                   "7Y", "10Y", "15Y")
      types <- "MMMMSSSSS"
      mmmDCC <- "ACT/365" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/365" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="SGD"){
      expiries <- c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", 
                   "5Y", "6Y", "7Y", "10Y", "12Y", "15Y", "20Y")
      types <- "MMMMMMSSSSSSSSSS"
      mmDCC <- "ACT/365" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/365" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var]=="HKD"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                   "7Y", "10Y", "12Y", "15Y")
      types <- "MMMMMSSSSSSSS"
      mmDCC <- "ACT/365" 
      fixedSwapFreq <- "3M" 
      floatSwapFreq <- "3M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/365" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    }
    
    ## if tenor is just a number i.e. written as just 5, then we turn it to the string "5Y"
    if(!is.null(x[[tenor.var]])) {  ## if tenor is provided
      x[i, tenor.var] <- as.character(x[i, tenor.var])      
      if(!grepl("Y", x[i, tenor.var])){
        x[i, tenor.var] <- paste(x[i, tenor.var], "Y", sep = "")
      }
      tenor <- x[i, tenor.var]
    } else {
      tenor <- NULL
    }
    
    if(is.null(x[[maturity.var]])){
      maturity <- NULL
    } else {
      maturity <- x[i, maturity.var]
    }
    
    results <- c(results, 
                 upfront(TDate = x[i, date.var],
                         currency = x[i, currency.var],                    
                         types = types,
                         rates = rates$rates[rates$date == as.Date(x[i,date.var]) & rates$currency == as.character(x[i, currency.var])],
                         expiries = expiries,                    
                         mmDCC = as.character(mmDCC),                    
                         fixedSwapFreq = as.character(fixedSwapFreq),
                         floatSwapFreq = as.character(floatSwapFreq),
                         fixedSwapDCC = as.character(fixedSwapDCC),
                         floatSwapDCC = as.character(floatSwapDCC),
                         badDayConvZC = as.character(badDayConvZC),
                         holidays = as.character(holidays),                   
                         maturity = maturity,
                         tenor = tenor,
                         parSpread = x[i, spread.var],
                         coupon = x[i, coupon.var],
                         recoveryRate = 0.4,
                         isPriceClean = isPriceClean,
                         calendar = calendar,
                         notional = notional))
  } 
  
  return(results)
}