## CDS.R test case for Norske Skogindustrier ASA (European company)

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      tenor = "5Y",
##                      contract ="STEC",
##                      parSpread = 2785.8889,
##                      upfront = 4412500,
##                      IRDV01 = -729.47, 
##                      price = 55.5,
##                      principal = 4450000, 
##                      RecRisk01 = -56513.77,
##                      defaultExpo = 1550000,
##                      spreadDV01 = 731.48, 
##                      currency = "EUR",
##                      ptsUpfront = 0.44,
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 500,
##                      recoveryRate = 0.40,
##                      defaultProb = 0.9128, 
##                      notional = 1e7)

## save(truth1, file = "CDS.NorskeSkogindustrier.test.RData")

load("CDS.NorskeSkogindustrier.test.RData")

result1 <- CDS(TDate = "2014-04-15",
               tenor = "5Y",
               contract ="STEC",
               parSpread = 2785.8889,
               currency = "EUR",
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

