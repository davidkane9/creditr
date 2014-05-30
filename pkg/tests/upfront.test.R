## Test. In the following test cases we compare the results of 
## our upront functions for different data with results from markit.com using
## the same data

library(CDS)

## test case to see if our function gives the same result as markit.com
## all cases use data from Xerox Corporation for 2014-04-22. 

# actual upfront value from markit.com for Xerox Corporation for 2014-04-22.
truth.1 <- 18624

result.1 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    maturity = "2019-06-20",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)

# Note: test case passes when rounded to the nearest tenth
expect_that(round(result.1, -1), equals(round(truth.1, -1)))

## In the following test cases we want to check if the result of changing
## certain variables is the same as the results from markit.com results.

## test case where spread is equal to the coupon 

## markit.com value
truth.2 <- -9444
## calculated value
result.2 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    maturity = "2019-06-20",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 100,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when the values are rounded off till the nearest whole
## number
expect_that(round(result.2), equals(truth.2))


## Effect on upfront of an increase in coupon rate (by 100 basis points). 

#actual value
truth.3 <- -474734
#calculated value
result.3 <- upfront(baseDate = "2014-04-22",
                    currency = "USD",
                    TDate = "2014-04-22",
                    tenor = "5Y",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 200,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when results are rounded off the nearest 100
expect_that(round(result.3, -2), equals(round(truth.3, -2)))


## Effect on upfront of an decrease in coupon rate (by 50 basis points). 

#actual value
truth.4 <- 265301
#calculated value
result.4 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    tenor = "5Y",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 50,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when results are rounded off the nearest 100
expect_that(round(result.4, -2), equals(round(truth.4, -2)))


## Effect on upfront of a decrease in trade date (by one week)

## actual value
truth.5 <- 20717
## calculated value
result.5 <- upfront(currency = "USD",
                    TDate = "2014-04-15",
                    tenor = "5Y",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when rounded to the nearest 10
expect_that(round(result.5, -1), equals(round(truth.5, -1)))


## Effect on upfront of an increase in the trade date (by one week)

## actual value
truth.6 <- 16581
#calculated value
result.6 <- upfront(currency = "USD",
                    TDate = "2014-04-29",
                    tenor = "5Y",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when rounded of to the nearest tenth
expect_that(round(result.6, -1), equals(round(truth.6, -1)))


## Effect on upfront of a decrease in the maturity date (by one quarter)

#actual value when maturity is 2019-09-20 instead of 2019-06-20
truth.7 <- 17387
#calculated value
result.7 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    maturity = "2019-03-20",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
expect_that(round(result.7, -1), equals(round(truth.7, -1)))

## Effect on upfront of an increase in the maturity date (by one quarter)

#actual value
truth.8 <- 19832
#calculated value
result.8 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    maturity = "2019-09-20",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when rounded off to the nearest 10.
expect_that(round(result.8, -1), equals(round(truth.8, -1)))

## Effect on upfront of an increase in spread (by 50 basis points)

#actual value
truth.9 <- 254969
#calculated value
result.9 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    maturity = "2019-06-20",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 155.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when rounded to nearest 1000
expect_that(round(result.9, -1), equals(round(truth.9, -1)))


## Effect on upfront of an decrease in spread (by 50 basis points)

#actual value
truth.10 <- -227905
#calculated value
result.10 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    maturity = "2019-06-20",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 55.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)
## comparing the results with markit data
## Note: test case passes when rounded off to the nearest 1000
expect_that(round(result.10, -1), equals(round(truth.10, -1)))


## Effect on upfront when trade date = maturity date (September 20, 2013)

#actual value
truth.11 <- 0
#calculated value
result.11 <- upfront(currency = "USD",
                    TDate = "2013-09-20",
                    maturity = "2013-09-20",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)

# comparing the results with markit data
## Note: test case passes when rounded off to the nearest 1000
expect_that(round(result.11), equals(round(truth.11)))



## test case to see an the effect on upfront when trade date = roll over date


## test case to see if upfront function produces different result when we
## enter the rates manually as a vector, instead of letting the function
## calculate it

result.12 <- upfront(TDate = "2014-04-22",
                    currency = "USD",                    
                    types = "MMMMMSSSSSSSS",
                    rates = c(1.522e-3, 1.929e-3, 2.259e-3, 3.198e-3, 5.465e-3, 5.380e-3, 10.000e-3, 1.4475e-2, 1.8165e-2, 2.1180e-2, 2.3490e-2, 2.5430e-2, 2.6955e-2),
                    expiries = c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),                    
                    mmDCC = "Act/360",                    
                    fixedSwapFreq = "6M",
                    floatSwapFreq = "6M",
                    fixedSwapDCC = "30/360",
                    floatSwapDCC = "30/360",
                    badDayConvZC = 'M',
                    holidays = 'None',                   
                    valueDate = "2014-04-25",
                    startDate = "2014-03-20",
                    endDate = "2019-06-20",
                    stepinDate = "2014-04-23",
                    tenor = "5Y",                    
                    dccCDS = "Act/360",
                    freqCDS = "1Q",
                    stubCDS = "f/s",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 105.8,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)

result.13 <- upfront(baseDate = "2014-04-22",
                   currency = "USD",
                   TDate = "2014-04-22",
                   tenor = "5Y",
                   dccCDS = "ACT/360",
                   freqCDS = "Q",
                   stubCDS = "F",
                   badDayConvCDS = "F",
                   calendar = "None",
                   parSpread = 105.8,
                   coupon = 100,
                   recoveryRate = 0.4,
                   isPriceClean = FALSE,
                   notional = 1e7)

## results are the same, as expected
expect_that(round(result.12, -1), equals(round(result.13, -1)))
