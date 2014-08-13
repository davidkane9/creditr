## CDS.R test case for Tokyo Electric Power Co. Inc.

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                     tenor = "5Y",
##                     contract ="STEC",
##                     parSpread = 250.00,
##                     upfront = 701502,
##                     IRDV01 = -184.69,
##                     price = 92.91,
##                     principal = 709002,
##                     RecRisk01 = -1061.74,
##                     defaultExpo = 5790998,
##                     spreadDV01 = 4448.92, 
##                     currency = "JPY",
##                     ptsUpfront = 0.0709,
##                     freqCDS = "Q",
##                     pencouponDate = as.Date("2019-03-20"),
##                     backstopDate = as.Date("2014-02-14"),
##                     coupon = 100,
##                     recoveryRate = 0.35,
##                     defaultProb = 0.1830,
##                     notional = 1e7)

## save(truth1, file = "CDS.TokyoElectricPower.test.RData")

load("CDS.TokyoElectricPower.test.RData")
result <- CDS(TDate = "2014-04-15",
               tenor = "5Y",
               baseDate = "2014-04-17",
               stepinDate = "2014-4-16",
               contract ="STEC",
               parSpread = 250,
               currency = "JPY",
               coupon = 100,
               recoveryRate = 0.35,
               isPriceClean = FALSE,
               notional = 1e7)

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences

expect_that(round(truth1$upfront, -1), equals(round(result@upfront, -1)))

expect_that(round(truth1$IRDV01), equals(round(result@IRDV01)))

expect_that(truth1$price, equals(round(result@price, 2)))

expect_that(round(truth1$principal, -1), equals(round(result@principal, -1)))

expect_that(round(truth1$RecRisk01, -2), equals(round(result@RecRisk01, -2)))

expect_that(round(truth1$defaultExpo, -1), equals(round(result@defaultExpo, -1)))

expect_that(round(truth1$spreadDV01), equals(round(result@spreadDV01)))

expect_that(round(truth1$ptsUpfront, 3), equals(round(result@ptsUpfront, 3)))
expect_that(as.character(truth1$freqCDS), equals(result@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result@freqCDS))

