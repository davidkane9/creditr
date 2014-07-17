## CDS.R test case for Electrolux AB corporation

library(CDS)

## truth.1 <- data.frame(TDate = as.Date("2014-04-22"),
##                      tenor = "5Y",
##                      contract ="STEC",
##                      parSpread = 99,
##                      upfront = -14368,
##                      IRDV01 = 1.29,
##                      price = 100.05,
##                      principal = -4924,
##                      RecRisk01 = 3.46,
##                      defaultExpo = 6004924,
##                      spreadDV01 = 4923.93,
##                      currency = "EUR",
##                      ptsUpfront = -0.00049239,
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-21"),
##                      coupon = 100,
##                      recoveryRate = 0.40,
##                      defaultProb = 0.0827,
##                      notional = 1e7)

## save(truth.1, file = "CDS.ElectroluxAB.test.RData")

load("CDS.ElectroluxAB.test.RData")
result.1 <- CDS(TDate = "2014-04-22",
               tenor = "5Y", 
               parSpread = 99,
               contract ="STEC",
               currency="EUR",
               coupon = 100,
               recoveryRate = 0.4,
               isPriceClean = FALSE,
               notional = 1e7)

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences 
## since Markit and Bloomberg round their results off to the nearest dollar
expect_that(round(truth.1$upfront), equals(round(result.1@upfront)))

expect_that(round(truth.1$IRDV01, 1), equals(round(result.1@IRDV01, 1)))

expect_that(truth.1$price, equals(round(result.1@price, 2)))

expect_that(round(truth.1$principal), equals(round(result.1@principal)))

expect_that(round(truth.1$RecRisk01, 1), equals(round(result.1@RecRisk01, 1)))

expect_that(round(truth.1$defaultExpo), equals(round(result.1@defaultExpo)))

expect_that(round(truth.1$spreadDV01), equals(round(result.1@spreadDV01)))

expect_that(round(truth.1$ptsUpfront, 4), equals(round(result.1@ptsUpfront, 4)))
expect_that(as.character(truth.1$freqCDS), equals(result.1@freqCDS))
expect_that(as.character(truth.1$freqCDS), equals(result.1@freqCDS))
