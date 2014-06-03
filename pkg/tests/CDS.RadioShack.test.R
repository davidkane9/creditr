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