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

  ## Note this is a hack! We need to get upfront to accept a date for maturity
  ## as opposed to something like 5Y.
    
  stopifnot(all(c(date.var, spread.var, coupon.var, maturity.var) %in% names(x)))
  stopifnot(inherits(as.Date(x[[date.var]]), "Date"))
  stopifnot(inherits(as.Date(x[[maturity.var]]), "Date"))
  stopifnot(is.numeric(notional))
  stopifnot(is.character(currency))
  stopifnot(is.numeric(x[[coupon.var]]))

  upfront <- upfront(currency = currency,
                     TDate = x[[date.var]],
                     maturity = "5Y", ## Should be x[[maturity.var]]
                     dccCDS = "ACT/360",
                     freqCDS = "Q",
                     stubCDS = "F",
                     badDayConvCDS = "F",
                     calendar = "None",
                     parSpread = x[[spread.var]],
                     coupon = x[[coupon.var]],
                     recoveryRate = 0.4,
                     isPriceClean = FALSE,
                     notional = notional)
    
return(upfront)
}