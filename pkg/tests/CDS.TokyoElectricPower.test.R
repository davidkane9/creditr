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
result1 <- CDS(TDate = "2014-04-15",
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
## upfront difference of 9.537495e-04 %
## expect_that(round(truth1$upfront, -1), equals(round(result1@upfront, -1)))

## IRDV01 difference of 3.988772e-02 %
#expect_that(round(truth1$IRDV01, -1), equals(round(result1@IRDV01, -1)))

## Price difference of -5.048511e-05 %
#xpect_that(truth1$price, equals(round(result1@price, 2)))

## Principal difference of 9.436605e-04 %
#expect_that(round(truth1$principal, -3), equals(round(result1@principal, -3)))

## Rec Risk 01 difference of -1.436737e+00 %
#expect_that(round(truth1$RecRisk01, -3), equals(round(result1@RecRisk01, -3)))

## defaultexpo difference of -1.155340e-04 %
#expect_that(round(truth1$defaultExpo, -3), equals(round(result1@defaultExpo, -3)))

## spreadDV01 difference of 1.040003e-03 %
#expect_that(round(truth1$spreadDV01), equals(round(result1@spreadDV01)))

## ptsUpfront difference of 6.615757e-04 %
#expect_that(round(truth1$ptsUpfront, 2), equals(round(result1@ptsUpfront, 2)))
#expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
#expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
