upfrontdf <- function(x, currency, notional,
                      date.var = "date", spread.var = "spread",
                        coupon.var = "coupon", maturity.var = "maturity"){

  stopifnot(all(c(date.var, spread.var, coupon.var, maturity.var) %in% names(x)))
  

  upfront <- upfront(currency = currency,
                     TDate = x[[date.var]],
                     maturity = x[[maturity.var]],
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