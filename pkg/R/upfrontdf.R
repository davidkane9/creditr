#' function that takes a dataframe of variables on CDSs to return a vector
#' of upfront values
#' 
#' @param x dataframe containing variables date, spread, coupon and maturity
#' @param currency of CDSs in the dataframe
#' @param notional values of CDSs in the dataframe
#' @param date.var name of the column containing dates
#' @param spread.var name of the column containing spreads
#' @param coupon.var name of the column containing the coupon rates
#' @param maturity.var name of the column containing the maturity dates
#' 
#' @return vector of upfront values in the same order

upfrontdf <- function(x, currency, notional,
                      date.var = "date", spread.var = "spread",
                        coupon.var = "coupon", maturity.var = "maturity"){

  ## as opposed to something like 5Y.
    
  stopifnot(all(c(date.var, spread.var, coupon.var, maturity.var) %in% names(x)))
  stopifnot(inherits(as.Date(x[[date.var]]), "Date"))
  stopifnot(inherits(as.Date(x[[maturity.var]]), "Date"))
  stopifnot(is.numeric(notional))
  stopifnot(is.character(currency))
  stopifnot(is.numeric(x[[coupon.var]]))

  ## Only works for data frames with one row now! And note the maturity hack!
  
  results <- as.numeric(rep(NA, nrow(x)))
  
  for(i in 1:nrow(x)){
    
    results[i] <- upfront(currency = currency,
                          TDate = x[i, date.var],
                          maturity = x[i, maturity.var],
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