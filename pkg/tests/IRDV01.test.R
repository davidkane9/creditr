## IRDV01.test case for Xerox corportation on April 22, 2014

library(CDS)


## actual value 
## truth1 <- -7.35

## save(truth1, file = "IRDV01.test.RData")

load("IRDV01.test.RData")

result1 <- IRDV01(TDate = "2014-04-22",
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

stopifnot(all.equal(round(result1), round(truth1)))
