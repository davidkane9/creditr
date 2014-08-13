## CDS.R test case for Caesars Entertainment Operating Co Inc using data obtainined from Bloomberg

library(CDS)

data(rates)

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

## rates from the relevant date

rates.20140415 <- rates$rates[rates$date == as.Date("2014-04-15") & rates$currency == "USD"]
expiries.20140415 <- rates$expiries[rates$date == as.Date("2014-04-15") & rates$currency == "USD"]

result1 <-  CDS(TDate = "2014-04-15",
        currency = "USD",                    
        types = "MMMMMSSSSSSSS",
        rates = rates.20140415,
        expiries = expiries.20140415,                    
        mmDCC = "Act/360",                    
        fixedSwapFreq = "6M",
        floatSwapFreq = "6M",
        fixedSwapDCC = "30/360",
        floatSwapDCC = "30/360",
        badDayConvZC = 'M',
        holidays = 'None',                   
        valueDate = "2014-04-18",
        startDate = "2014-03-20",
        endDate = "2019-06-20",
        stepinDate = "2014-04-16",
        maturity = "2019-06-20",                    
        dccCDS = "Act/360",
        freqCDS = "Q",
        stubCDS = "f/s",
        badDayConvCDS = "F",
        calendar = "None",
        parSpread = 12354.529,
        coupon = 500,
        recoveryRate = 0.4,
        isPriceClean = FALSE,
        notional = 1e7)

## comparing results with true values from Bloomberg
## The results have to be rounded off as there are marginal differences

expect_that(round(truth1$upfront, -1), equals(round(result1@upfront, -1)))
#true result is 5707438 whereas the package returns 5707436
#expect_equal(5707438, result1@upfront)

expect_that(round(truth1$IRDV01, 1), equals(round(result1@IRDV01, 1)))
#expect_equal(-271.18, result1@IRDV01)

expect_that(truth1$price, equals(round(result1@price, 2)))
#expect_equal(42.55, result1@price)

expect_that(round(truth1$principal, -1), equals(round(result1@principal, -1)))
#expect_equal(5744938, result1@principal)

expect_that(round(truth1$RecRisk01, -2), equals(round(result1@RecRisk01, -2)))

expect_that(round(truth1$defaultExpo, -1), equals(round(result1@defaultExpo, -1)))

expect_that(round(truth1$spreadDV01, 2), equals(round(result1@spreadDV01, 2)))

expect_that(round(truth1$ptsUpfront, 4), equals(round(result1@ptsUpfront, 4)))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
expect_that(as.character(truth1$freqCDS), equals(result1@freqCDS))
