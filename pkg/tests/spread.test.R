## spread() test case with data from Xerox corporation
library(CDS)

## actual spread value from Bloomberg for Xerox Corp.
## truth1 <- 105.85
## save(truth1, file="spread.test.RData")

load("spread.test.RData")

result1 <- spread(TDate = "2014-04-22",
                  currency = "USD",
                  tenor = "5Y",
                  types = "MMMMMSSSSSSSSS",
                  rates = c(1.522e-3, 1.929e-3, 2.259e-3, 3.198e-3, 5.465e-3, 5.380e-3, 10.000e-3, 1.4475e-2, 1.8165e-2, 2.1180e-2, 2.3490e-2, 2.5430e-2, 2.6955e-2, 2.8250e-2),
                  expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
                  
                  mmDCC = "Act/360",
                  fixedSwapFreq = "6M",
                  floatSwapFreq = "6M",
                  fixedSwapDCC = "30/360",
                  floatSwapDCC = "30/360",
                  badDayConvZC = 'M',
                  holidays = 'None',
                  
                  valueDate = "2014-04-25",
                  benchmarkDate = "2013-12-20",
                  startDate = "2014-03-20",
                  endDate = "2019-06-20",
                  stepinDate = "2014-04-23",

                  dccCDS = "ACT/360",
                  freqCDS = 'Q',		  
                  stubCDS = "F", 		
                  badDayConvCDS = "F",
                  calendar = 'None',

                  upfront = 18624,
                  coupon = 100, 
                  recoveryRate = .4,
                  payAccruedAtStart = FALSE,
                  notional = 1e7,
                  payAccruedOnDefault = TRUE)

## test passes when results are rounded off to the second decimal place
stopifnot(all.equal(round(result1, 2), truth1))

## results when we don't enter the rates manually are less accurate 
## result2 <- spread(TDate = "2014-04-22",
##                  baseDate = "2014-04-22",
##                  currency = "USD",
##                  tenor = "5Y",
##                  
##                  dccCDS = "ACT/360",
##                  freqCDS = 'Q',		  
##                  stubCDS = "F", 		
##                  badDayConvCDS = "F",
##                  calendar = 'None',
##
##                  upfront = 18624,
##                  coupon = 100, 
##                  recoveryRate = .4,
##                  payAccruedAtStart = TRUE,
##                  notional = 1e7,
##                  payAccruedOnDefault = TRUE)


## stopifnot(all.equal(result2, truth2))
