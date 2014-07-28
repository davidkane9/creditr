## CDS.R test case for Caesars Entertainment Operating Co Inc

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##              tenor = "5Y",
##              contract ="SNAC",
##              parSpread = 12354.53,
##              upfront = 5707438,
##              IRDV01 = -271.18,
##              price = 42.55,
##              principal = 5744938,
##              RecRisk01 = -95430.32, 
##              defaultExpo = 255062,
##              spreadDV01 = 21.15,
##              currency = "USD",
##              ptsUpfront = 0.5745,
##              freqCDS = "Q",
##              pencouponDate = as.Date("2019-03-20"),
##              backstopDate = as.Date("2014-02-14"),
##              coupon = 500,
##              recoveryRate = 0.40,
##              defaultProb = 0.99998, 
##              notional = 1e7)

## save(truth1, file = "CDS.CaesarsEntCorp.test.RData")

load("CDS.CaesarsEntCorp.test.RData")

result1 <- CDS(TDate = "2014-04-15",
               tenor = "5Y",
               parSpread = 12354.529,
               currency = "USD",
               coupon = 500,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences

expect_that(round(truth1$upfront, -1), equals(round(result1@upfront, -1)))

expect_that(round(truth1$IRDV01, 1), equals(round(result1@IRDV01, 1)))

expect_that(truth1$price, equals(round(result1@price, 2)))

expect_that(round(truth1$principal, -1), equals(round(result1@principal, -1)))

expect_that(round(truth1$RecRisk01, -2), equals(round(result1@RecRisk01, -2)))

expect_that(round(truth1$defaultExpo, -1), equals(round(result1@defaultExpo, -1)))

expect_that(round(truth1$spreadDV01, 2), equals(round(result1@spreadDV01, 2)))

expect_that(round(truth1$ptsUpfront, 4), equals(round(result1@ptsUpfront, 4)))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
