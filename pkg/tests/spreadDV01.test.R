## SpreadDV01.test.R using CDS data for Xerox Corp on April 22, 2014
library(CDS)

## actual spread for Xerox
## truth1 <- 4825.49

## save(truth1, file = "spreadDV01.test.RData")

load("spreadDV01.test.RData")

result1 <- spreadDV01(TDate = "2014-04-22",
                      currency = "USD",
                      tenor = "5Y",
                      dccCDS = "Act/360",
                      freqCDS = "1Q",
                      stubCDS = "F",
                      badDayConvCDS = "F",
                      calendar = "None",
                      parSpread = 105.8,
                      coupon = 100,
                      recoveryRate = 0.4,
                      notional = 1e7)

## test case passes when results are rounded to the nearest whole number

stopifnot(all.equal(round(result1, 0), round(truth1, 0)))
