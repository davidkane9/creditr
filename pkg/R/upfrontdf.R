upfrontdf <- function(x, date.var = "date", spread.var = "spread",
                        coupon.var = "coupon", maturity.var = "maturity", 
                        currency.var = "currency", notional.var = "notional"){
    # date.var <- x[date.var]
    # spread.var <- x[spread.var]
    # coupon.var <- x[coupon.var]
    # maturity.var <- x[maturity.var]
    # notional.var <- x[notional.var]
    # currency.var <- x[currency.var]
    # x <- data.frame(date.var, spread.var, coupon.var, maturity.var,
                    notional.var, currency.var)
    upfront <- NULL
    upfront <- c(upfront, upfront(currency = "USD",
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
                     notional = x[[notional.var]]))
    return(upfront)
}