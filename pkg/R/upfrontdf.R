upfrontdf <- function(x, currency, notional,
                      date.var = "date", spread.var = "spread",
                        coupon.var = "coupon", maturity.var = "maturity"){

  ## Note this is a hack! We need to get upfront to accept a date for maturity
  ## as opposed to something like 5Y.
    
  stopifnot(all(c(date.var, spread.var, coupon.var, maturity.var) %in% names(x)))
  stopifnot(inherits(as.Date(x[[date.var]]), "Date"))
  stopifnot(inherits(as.Date(x[[maturity.var]]), "Date"))  

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