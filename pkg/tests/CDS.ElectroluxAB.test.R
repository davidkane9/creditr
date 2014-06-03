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

expect_that(truth1$TDate, equals(result1@TDate))
expect_that(as.character(truth1$tenor), equals(result1@tenor))
expect_that(as.character(truth1$contract), equals(result1@contract))
expect_that(truth1$parSpread, equals(result1@parSpread))
expect_that(truth1$upfront, equals(result1@upfront))
expect_that(truth1$IRDV01, equals(result1@IRDV01))
expect_that(truth1$price, equals(result1@price))
expect_that(truth1$principal, equals(result1@principal))
expect_that(truth1$RecRisk01, equals(result1@RecRisk01))
expect_that(truth1$defaultExpo, equals(result1@defaultExpo))
expect_that(truth1$spreadDV01, equals(result1@spreadDV01))
expect_that(as.character(truth1$currency), equals(result1@currency))
expect_that(truth1$ptsUpfront, equals(result1@ptsUpfront))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))