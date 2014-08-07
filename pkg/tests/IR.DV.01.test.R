## IRDV01.test case for Xerox corportation on April 22, 2014

library(CDS)


## actual value 
## truth.1 <- -7.35

## save(truth.1, file = "IR.DV.01.test.RData")

load("IR.DV.01.test.RData")

result.1 <- IR.DV.01(TDate = "2014-04-22",
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

stopifnot(all.equal(round(result.1), round(truth.1)))
