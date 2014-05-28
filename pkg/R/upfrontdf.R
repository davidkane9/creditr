> upfrontdf <- function(x, date.var = "date", spread.var = "spread",
                        coupon.var = "coupon", maturity.var = "maturity", 
                        currency.var = "currency", notional.var = "notional"){
  date.var <- x[date.var]
  spread.var <- x[spread.var]
  coupon.var <- x[coupon.var]
  maturity.var <- x[maturity.var]
  notional.var <- x[notional.var]
  currency.var <- x[currency.var]
  upfront <- NULL
  for(i in 1:length(date)){
    upfront <- c(upfront, upfront(currency = "USD",
                              TDate = as.Date(date.var[i]),
                              maturity = (as.Date(maturity.var[i]),
                              dccCDS = "ACT/360",
                              freqCDS = "Q",
                              stubCDS = "F",
                              badDayConvCDS = "F",
                              calendar = "None",
                              parSpread = spread.var[i],
                              coupon = coupon.var[i],
                              recoveryRate = 0.4,
                              isPriceClean = FALSE,
                              notional = notional.var[i]))
  }
  return(upfront)
}