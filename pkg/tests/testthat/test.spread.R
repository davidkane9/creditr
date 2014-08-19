context("Test spread")

## spread() test case with data from Xerox corporation

test_that("test for spread", {
  ## actual spread value from Bloomberg for Xerox Corp.
   truth.1 <- 105.85
  
  load("spread.test.RData")
  
  result.1 <- spread(date = as.Date("2014-04-22"),
                     currency = "USD",
                     tenor = 5,
                     types = "MMMMMSSSSSSSSSSSSSS",
                     rates = c(1.522e-3, 1.929e-3, 2.259e-3, 3.198e-3, 5.465e-3, 
                               5.380e-3, 1.000e-2, 1.4475e-2, 1.8165e-2, 2.1180e-2, 
                               2.3490e-2, 2.5430e-2, 2.6955e-2, 2.8250e-2, 3.0275e-2,
                               3.2285e-2, 3.3970e-2, 3.4730e-2, 3.5070e-2),
                     expiries = c("1M", "2M", "3M", "6M", "12M", "2Y", "3Y", 
                                  "4Y", "5Y", "6Y", "7Y", "8Y", "9Y", "10Y", "12Y",
                                  "15Y", "20Y", "25Y", "30Y"),                  
                     
                     valueDate = "2014-04-25",
                     benchmarkDate = "2013-12-20",
                     startDate = "2014-03-20",
                     endDate = "2019-06-20",
                     stepinDate = "2014-04-23",
     
                     upfront = 18624,
                     coupon = 100, 
                     recovery.rate = .4,
                     payAccruedAtStart = FALSE,
                     notional = 1e7,
                     payAccruedOnDefault = TRUE,
                   
                     mmDCC = "Act/360",
                     fixedSwapFreq = "6M",
                     floatSwapFreq = "6M",
                     fixedSwapDCC = "30/360",
                     floatSwapDCC = "30/360",
                     badDayConvZC = 'M',
                     holidays = 'None',
                     dccCDS = "ACT/360",
                     freqCDS = 'Q',      
                     stubCDS = "F", 		
                     badDayConvCDS = "F",
                     calendar = 'None')
  
  ## test passes when results are rounded off to the second decimal place
  
  stopifnot(all.equal(round(result.1, 2), round(truth.1, 1)))
  
  
  ## results when we don't enter the rates manually are less accurate 
  
  result.2 <- spread(date = as.Date("2014-04-22"),
                     baseDate = "2014-04-22",
                     currency = "USD",
                     tenor = 5,
                     
                     dccCDS = "ACT/360",
                     freqCDS = 'Q',		  
                     stubCDS = "F", 		
                     badDayConvCDS = "F",
                     calendar = 'None',
                     
                     upfront = 18623.7,
                     coupon = 100, 
                     recovery.rate = 0.4,
                     payAccruedAtStart = FALSE,
                     notional = 1e7,
                     payAccruedOnDefault = TRUE)
  
  
  stopifnot(all.equal(round(result.2), round(truth.1)))
  
  
  ## test cases to make sure results of the function don't change over time
  
   truth.2 <- spread(date = "2014-01-14",
                    currency = "USD",
                    tenor = 5,
                    types = "MMMMMSSSSSSSSS",
                    rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
                    expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
                    mmDCC = "Act/360",
                    fixedSwapFreq = "6M",
                    floatSwapFreq = "6M",
                    fixedSwapDCC = "30/360",
                    floatSwapDCC = "30/360",
                    badDayConvZC = 'M',
                    holidays = 'None',
  
                    valueDate = "2014-01-17",
                    benchmarkDate = "2013-12-20",
                    startDate = "2013-12-20",
                    endDate = "2019-03-20",
                    stepinDate = "2014-01-15",
  
                    dccCDS = "ACT/360",
                    freqCDS = 'Q',  	  
                    stubCDS = "F", 		
                    badDayConvCDS = "F",
                    calendar = 'None',
  
                    upfront = -1e7*3.48963/100,
                   coupon = 100, 
                    recovery.rate = .4,
                    payAccruedAtStart = FALSE,
                  notional = 1e7,
                    payAccruedOnDefault = TRUE)
  
   truth.3 <- spread(date = "2014-01-14",
                    baseDate = "2014-01-13",
                    currency = "USD",
                    tenor = 5,
  
                    dccCDS = "ACT/360",
                    freqCDS = 'Q',		  
                    stubCDS = "F", 		
                    badDayConvCDS = "F",
                    calendar = 'None',
  
                    upfront = -1e7*3.41/100,
                    coupon = 100, 
                    recovery.rate = .4,
                    payAccruedAtStart = TRUE,
                    notional = 1e7,
                    payAccruedOnDefault = TRUE)
  ## save(truth.1, truth.2, truth.3, file = "spread.test.RData")
  
  load("spread.test.RData")
  
  result.3 <- spread(date = as.Date("2014-01-14"),
                     currency = "USD",
                     tenor = 5,
                     types = "MMMMMSSSSSSSSS",
                     rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
                     expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
                     
                     mmDCC = "Act/360",
                     fixedSwapFreq = "6M",
                     floatSwapFreq = "6M",
                     fixedSwapDCC = "30/360",
                     floatSwapDCC = "30/360",
                     badDayConvZC = 'M',
                     holidays = 'None',
                     
                     valueDate = "2014-01-17",
                     benchmarkDate = "2013-12-20",
                     startDate = "2013-12-20",
                     endDate = "2019-03-20",
                     stepinDate = "2014-01-15",
                     
                     dccCDS = "ACT/360",
                     freqCDS = 'Q',		  
                     stubCDS = "F", 		
                     badDayConvCDS = "F",
                     calendar = 'None',
                     
                     upfront = -1e7*3.48963/100,
                     coupon = 100, 
                     recovery.rate = .4,
                     payAccruedAtStart = FALSE,
                     notional = 1e7,
                     payAccruedOnDefault = TRUE)
  
  stopifnot(all.equal(result.3, truth.2))
  
  result.4 <- spread(date = as.Date("2014-01-14"),
                     baseDate = "2014-01-13",
                     currency = "USD",
                     tenor = 5,
                     
                     dccCDS = "ACT/360",
                     freqCDS = 'Q',		  
                     stubCDS = "F", 		
                     badDayConvCDS = "F",
                     calendar = 'None',
                     
                     upfront = -1e7*3.41/100,
                     coupon = 100, 
                     recovery.rate = .4,
                     payAccruedAtStart = TRUE,
                     notional = 1e7,
                     payAccruedOnDefault = TRUE)
  
  stopifnot(all.equal(result.4, truth.3))
  
})
