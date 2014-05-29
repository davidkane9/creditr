#test case for update function.
library(CDS)

#test case with upfront data from Ceasars Entertainment Corp for 2014-04-15.

CaesarsEntCorp <- 5707438

result.1 <- upfront(currency = "USD",
                    TDate = "2014-04-15",
                    maturity = "5Y",
                    dccCDS = "ACT/360",
                    freqCDS = "Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    parSpread = 12354.53,
                    coupon = 500,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    notional = 1e7)

expect_that(result.1, equals(result.1))

#test case with upfront data from Xerox Corporation for 2014-04-22. 

xerox <- 18624

result.2 <- upfront(currency = "USD",
                    TDate = "2014-04-22",
                    maturity = "5Y",
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

expect_that(result.2, equals(xerox))