# test case for upfrontdf for one row of data
library(CDS)
date = c("2014-01-14")
maturity = c("2019-01-14")
notional = c(1e7)
coupon = c(100)
currency = c("USD")
spread = c(32)

X <- data.frame(date, maturity, notional, coupon, currency, spread)

truth1 <- c()

upfront(currency = "USD",
        TDate = as.Date("2014-01-14"),
        maturity = (as.Date("2019-01-14") - as.Date("2014-01-14"))/365,
        dccCDS = "ACT/360",
        freqCDS = "Q",
        stubCDS = "F",
        badDayConvCDS = "F",
        calendar = "None",
        parSpread = 32,
        coupon = 100,
        recoveryRate = 0.4,
        isPriceClean = FALSE,
        notional = 1e7)