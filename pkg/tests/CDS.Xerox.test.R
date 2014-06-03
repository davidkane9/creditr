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
