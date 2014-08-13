## CDS.R test case for Xerox corporation

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-22"),
##                     tenor = "5Y",
##                     contract ="SNAC",
##                     parSpread = 105.8,
##                     upfront = 18624,
##                      IRDV01 = -7.36,
##                      price = 99.72,
##                      principal = 28068,
##                      RecRisk01 = -20.85,
##                      defaultExpo = 5971932,
##                      spreadDV01 = 4825.49, 
##                      currency = "USD",
##                      ptsUpfront = 0.0028, 
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-21"),
##                      coupon = 100,
##                      recoveryRate = 0.40,
##                      defaultProb = 0.0880,
##                     notional = 1e7)

## save(truth1, file = "CDS.Xerox.test.RData")

load("CDS.Xerox.test.RData")
result1 <- CDS(TDate = "2014-04-22",
               tenor = "5Y", 
               parSpread = 105.8,
               coupon = 100,
               recoveryRate = 0.4,
               isPriceClean = FALSE,
               notional = 1e7)

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences

expect_that(round(truth1$upfront), equals(round(result1@upfront)))

expect_that(round(truth1$IRDV01, 1), equals(round(result1@IRDV01, 1)))

expect_that(truth1$price, equals(round(result1@price, 2)))

expect_that(round(truth1$principal), equals(round(result1@principal)))

expect_that(round(truth1$RecRisk01), equals(round(result1@RecRisk01)))

expect_that(round(truth1$defaultExpo), equals(round(result1@defaultExpo)))

expect_that(round(truth1$spreadDV01, 2), equals(round(result1@spreadDV01, 2)))

expect_that(round(truth1$ptsUpfront, 4), equals(round(result1@ptsUpfront, 4)))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))