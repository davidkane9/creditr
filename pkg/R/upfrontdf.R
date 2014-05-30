#' function that takes a dataframe of variables on CDSs to return a vector
#' of upfront values
#' 
#' @param x dataframe containing variables date, spread, coupon and maturity
#' @param rates dataframe containing dates and rates for those dates
#' @param currency of CDSs in the dataframe
#' @param notional values of CDSs in the dataframe
#' @param date.var name of the column containing dates
#' @param spread.var name of the column containing spreads
#' @param coupon.var name of the column containing the coupon rates
#' @param maturity.var name of the column containing the maturity dates (note: this
#' is different from tenor i.e. it is a proper date like "2019-06-20" and not "5Y")
#' 
#' @return vector of upfront values in the same order

upfrontdf <- function(x,
                      rates, 
                      currency, 
                      notional,
                      date.var = "date", 
                      spread.var = "spread",
                      coupon.var = "coupon", 
                      maturity.var = "maturity"){
    
  stopifnot(all(c(date.var, spread.var, coupon.var, maturity.var) %in% names(x)))
  stopifnot(inherits(as.Date(x[[date.var]]), "Date"))
  stopifnot(inherits(as.Date(x[[maturity.var]]), "Date"))
  stopifnot(is.numeric(notional))
  stopifnot(is.character(currency))
  stopifnot(is.numeric(x[[coupon.var]]))
  ## stop if one of the dates in the X data frame does not have a corresponding
  ## interest rate curve in the rates data frame.
  stopifnot(!(FALSE%in%check.Rates.Dates(X, rates))
  
  rates.dates <- rates[[rate, date%in%x$date]]
  
  results <- as.numeric(rep(NA, nrow(x)))
  
  for(i in 1:nrow(x)){
    
    results[i] <- upfront(currency = currency,
                          TDate = x[i, date.var],
                          maturity = x[i, maturity.var],
                          rates = c()
                          dccCDS = "ACT/360",
                          freqCDS = "Q",
                          stubCDS = "F",
                          badDayConvCDS = "F",
                          calendar = "None",
                          parSpread = x[i, spread.var],
                          coupon = x[i, coupon.var],
                          recoveryRate = 0.4,
                          isPriceClean = FALSE,
                          notional = notional)
  }
  
  return(results)

}