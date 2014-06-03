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