## CDS.R test case for RadioShack Corp

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      tenor = "5Y",
##                      contract ="SNAC",
##                      parSpread = 9106.8084,
##                      upfront = 5612324,
##                      IRDV01 = -361.62,
##                      price = 43.5,
##                      principal = 5649824, 
##                      RecRisk01 = -93430.52, 
##                      defaultExpo = 350176, 
##                      spreadDV01 = 40.86, 
##                      currency = "USD",
##                      ptsUpfront = 0.5649, 
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 500,
##                      recoveryRate = 0.40,
##                      defaultProb = 0.9997,
##                      notional = 1e7)

## save(truth1, file = "CDS.RadioShack.test.RData")

load("CDS.RadioShack.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               tenor = "5Y",
               parSpread = 9106.8084,
               currency = "USD",
               coupon = 500,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences

expect_that(round(truth1$upfront, -1), equals(round(result1@upfront, -1)))

expect_that(round(truth1$IRDV01, 0), equals(round(result1@IRDV01, 0)))

expect_that(truth1$price, equals(round(result1@price, 1)))

expect_that(round(truth1$principal, -1), equals(round(result1@principal, -1)))

expect_that(round(truth1$RecRisk01, -3), equals(round(result1@RecRisk01, -3)))

expect_that(round(truth1$defaultExpo, -1), equals(round(result1@defaultExpo, -1)))

expect_that(round(truth1$spreadDV01, 1), equals(round(result1@spreadDV01, 1)))

expect_that(round(truth1$ptsUpfront, 2), equals(round(result1@ptsUpfront, 2)))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))