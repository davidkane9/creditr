## CDS.R test case for Chorus Ltd. (Australian company)

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      tenor = "5Y",
##                      contract ="SNZC",
##                      parSpread = 243.28,
##                      upfront = 650580,
##                      IRDV01 = -169.33,
##                      price = 93.42,
##                      principal = 658080,
##                      RecRisk01 = -1106.34,
##                      defaultExpo = 5341920,
##                      spreadDV01 = 4317.54, 
##                      currency = "USD",
##                      ptsUpfront = 0.065808,
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 100,
##                      recoveryRate = 0.40,
##                      defaultProb = 0.1915,
##                      notional = 1e7)

## save(truth1, file = "CDS.Chorus.test.RData")

load("CDS.Chorus.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               maturity = "2019-06-20",
               contract ="SNZC",
               parSpread = 243.28,
               currency = "USD",
               coupon = 100,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences
## upfront difference of 0.0071624079 %
expect_that(round(truth1$upfront), equals(round(result1@upfront)))

## IRDV01 difference of 0.0288930347 %
expect_that(round(truth1$IRDV01, 1), equals(round(result1@IRDV01, 1)))

## Price difference of 0.0003575552 %
expect_that(truth1$price, equals(round(result1@price, 2)))

## Principal difference of 0.0070807794 %
expect_that(round(truth1$principal), equals(round(result1@principal)))

## Rec Risk 01 difference of -1.5431723833 %
expect_that(round(truth1$RecRisk01, -2), equals(round(result1@RecRisk01, -2)))

## defaultexpo difference of -0.0008722930 %
expect_that(round(truth1$defaultExpo), equals(round(result1@defaultExpo)))

## spreadDV01 difference of -0.0117456912 %
expect_that(round(truth1$spreadDV01), equals(round(result1@spreadDV01)))

## ptsUpfront difference of 0.0070807794 %
expect_that(round(truth1$ptsUpfront, 4), equals(round(result1@ptsUpfront, 4)))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
