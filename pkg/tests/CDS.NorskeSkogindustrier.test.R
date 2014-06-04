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

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences
## upfront difference of $162 or 0.0036618077 %
expect_that(round(truth1$upfront, -3), equals(round(result1@upfront, -3)))

## IRDV01 difference of 0.0389509648 %
expect_that(round(truth1$IRDV01, 0), equals(round(result1@IRDV01, 0)))

## Price difference of -0.0029113021 %
expect_that(truth1$price, equals(round(result1@price, 2)))

## Principal difference of 0.0036309498 %
expect_that(round(truth1$principal, -3), equals(round(result1@principal, -3)))

## Rec Risk 01 difference of -0.4424250576 %
expect_that(round(truth1$RecRisk01, -3), equals(round(result1@RecRisk01, -3)))

## defaultexpo difference of -0.0104243396 %
expect_that(round(truth1$defaultExpo, -3), equals(round(result1@defaultExpo, -3)))

## spreadDV01 difference of -0.0006907027 %
expect_that(round(truth1$spreadDV01), equals(round(result1@spreadDV01)))

## ptsUpfront difference of -1.1326914258 %
expect_that(round(truth1$ptsUpfront, 2), equals(round(result1@ptsUpfront, 2)))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
