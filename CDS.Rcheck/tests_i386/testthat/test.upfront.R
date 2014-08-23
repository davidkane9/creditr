context("Test upfront")

## Test. In the following test cases we compare the results of 
## our upront functions for different data with results from markit.com using
## the same data

library(CDS)

test_that("test for upfront", {
  
  data(rates)
  
  ## test case to see if our function gives the same result as markit.com
  ## all cases use data from Xerox Corporation for 2014-04-22. 
  
  load("upfront.test.RData")
  
  ## actual upfront value from markit.com for Xerox Corporation for 2014-04-22.
  
  ## truth.1 <- 18624
  
  rates.1 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.1 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                 currency = "USD",
                                 tenor = 5,
                                 spread = 105.8,
                                 coupon = 100,
                                 recovery = 0.4), rates = rates.1, isPriceClean = FALSE)
  
  ## Note: test case passes when rounded to the nearest tenth.
  ## Difference of 3.39 (0.02094072 %) from actual value
  
  expect_that(round(result.1), equals(round(truth.1)))
  
  ## In the following test cases we want to check if the result of changing
  ## certain variables is the same as the results from markit.com results.
  
  ## test case where spread is equal to the coupon 
  
  ## markit.com value
  ## truth.2 <- -9444
  ## calculated value
  
  rates.2 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.2 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                 currency = "USD",
                                 tenor = 5,
                                 spread = 100,
                                 coupon = 100,
                                 recovery = 0.4), rates = rates.2, isPriceClean = FALSE)
  
  ## comparing the results with markit data
  ## Note: test case passes when the values are rounded off till the nearest whole
  ## number
  ## difference of 0.444 from actual number
  
  expect_that(round(result.2), equals(truth.2))
  
  
  ## Effect on upfront of an increase in coupon rate (by 100 basis points). 
  
  ## actual value
  ## truth.3 <- -474755
  ## calculated value
  
  
  rates.3 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.3 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                 currency = "USD",
                                 tenor = 5,
                                 spread = 105.8,
                                 coupon = 200,
                                 recovery = 0.4), rates = rates.3, isPriceClean = FALSE)
  
  ## comparing the results with markit data
  ## Note: test case passes when results are rounded off the nearest 100
  ## difference of $14 (0.00294902 %) from actual number
  
  expect_that(round(result.3), equals(round(truth.3)))
  
  
  ## Effect on upfront of an decrease in coupon rate (by 50 basis points). 
  
  ## actual value
  ## truth.4 <- 265313
  ## calculated value
  
  
  rates.4 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.4 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                 currency = "USD",
                                 tenor = 5,
                                 spread = 105.8,
                                 coupon = 50,
                                 recovery = 0.4), rates = rates.4, isPriceClean = FALSE)
  
  ## comparing the results with markit data
  ## Note: test case passes when results are rounded off the nearest 100
  ## difference of $8.408048 (0.003169249 %) from actual number
  
  expect_that(round(result.4), equals(round(truth.4)))
  
  
  ## Effect on upfront of a decrease in trade date (by one week)
  
  ## actual value
  ## truth.5 <- 20718
  ## calculated value
  
  
  rates.5 <- get.rates(as.Date("2014-04-15"), currency = "USD")[1:13,]
  
  result.5 <- upfront(data.frame(date = as.Date("2014-04-15"),
                                 currency = "USD",
                                 maturity = "2019-06-20",
                                 spread = 105.8,
                                 coupon = 100,
                                 recovery = 0.4), rates = rates.5, isPriceClean = FALSE)
  
  ## comparing the results with markit data
  ## Note: test case passes when rounded to the nearest 10
  ## difference of $0.9439034 (0.004556178 %) from actual number
  
  expect_that(round(result.5), equals(round(truth.5)))
  
  
  ## Effect on upfront of an increase in the trade date (by one week)
  
  ## actual value
  ## truth.6 <- 16582
  #calculated value
  rates.6 <- get.rates(as.Date("2014-04-29"), currency = "USD")[1:13,]
  
  result.6 <- upfront(data.frame(date = as.Date("2014-04-29"),
                                 currency = "USD",
                                 maturity = "2019-06-20",
                                 spread = 105.8,
                                 coupon = 100,
                                 recovery = 0.4), rates = rates.6, isPriceClean = FALSE)
  
  ## comparing the results with markit data
  ## Note: test case passes when rounded of to the nearest tenth
  
  expect_that(round(result.6), equals(round(truth.6)))
  
  
  ## Effect on upfront of a decrease in the maturity date (by one quarter)
  
  ## actual value when maturity is 2019-09-20 instead of 2019-06-20
  ## truth.7 <- 17395
  #calculated value
  
  rates.7 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.7 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                 currency = "USD",
                                 maturity = "2019-03-20",
                                 spread = 105.8,
                                 coupon = 100,
                                 recovery = 0.4), rates = rates.7, isPriceClean = FALSE)
  
  ## comparing the results with markit data
  
  expect_that(round(result.7), equals(round(truth.7)))
  
  
  ## Effect on upfront of an increase in the maturity date (by one quarter)
  
  ## actual value
  ## truth.8 <- 19836
  ## calculated value
  
  
  rates.8 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.8 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                 currency = "USD",
                                 maturity = "2019-09-20",
                                 spread = 105.8,
                                 coupon = 100,
                                 recovery = 0.4), rates = rates.8, isPriceClean = FALSE)
  
  
  ## comparing the results with markit data
  ## Note: test case passes when rounded off to the nearest 10.
  
  expect_that(round(result.8), equals(round(truth.8)))
  
  ## Effect on upfront of an increase in spread (by 50 basis points)
  
  ## actual value
  ## truth.9 <- 254985
  ## calculated value
  
  
  rates.9 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.9 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                 currency = "USD",
                                 tenor = 5,
                                 spread = 155.8,
                                 coupon = 100,
                                 recovery = 0.4), rates = rates.9, isPriceClean = FALSE)
  
  ## comparing the results with markit data
  ## Note: test case passes when rounded to nearest 1000
  
  expect_that(round(result.9), equals(round(truth.9)))
  
  
  ## Effect on upfront of an decrease in spread (by 50 basis points)
  
  ## actual value
  ## truth.10 <- -227912
  ## calculated value
  
  rates.10 <- get.rates(as.Date("2014-04-22"), currency = "USD")[1:13,]
  
  result.10 <- upfront(data.frame(date = as.Date("2014-04-22"),
                                  currency = "USD",
                                  tenor = 5,
                                  spread = 55.8,
                                  coupon = 100,
                                  recovery = 0.4), rates = rates.10, isPriceClean = FALSE)
  
  
  ## comparing the results with markit data
  ## Note: test case passes when rounded off to the nearest 1000
  
  expect_that(round(result.10), equals(round(truth.10)))
  
  
  ## Effect on upfront when trade date = maturity date (September 20, 2013)
  
  ## actual value
  ## truth.11 <- 0
  ## calculated value
  ## 
  
  rates.11 <- get.rates(as.Date("2013-09-20"), currency = "USD")[1:13,]
  
  result.11 <- upfront(data.frame(date = as.Date("2013-09-20"),
                                  currency = "USD",
                                  maturity = "2013-09-20",
                                  spread = 105.8,
                                  coupon = 100,
                                  recovery = 0.4), rates = rates.11, isPriceClean = FALSE)
  
  
  # comparing the results with markit data
  ## Note: test case passes when rounded off to the nearest 1000
  ## expect_that(round(result.11), equals(round(truth.11)))
  
  
  ## save(truth.1, truth.2, truth.3, truth.4, truth.5, truth.6, truth.7, 
  ##     truth.8, truth.9, truth.10, truth.11, file="upfront.test.RData")
  
  ## test case to see an the effect on upfront when trade date = roll over date
  
  ## test case to see upfront payment when trade date is one day away from 
  ## maturity date
  
  ## test for different Japanese dates
  
  rates.13 <- get.rates(as.Date("2009-03-18"), currency = "USD")[1:13,]
  
  result.13 <- upfront(data.frame(date = as.Date("2009-03-18"),
                                  currency = "JPY",
                                  maturity = "2014-03-20",
                                  spread = 105.8,
                                  coupon = 100,
                                  recovery = 0.35), rates = rates.13, isPriceClean = FALSE)
  
  truth.13 <- 3487
  
  expect_true(abs(result.13 - truth.13) < 5)
})


## more test cases for upfront  

## retrieve interest rates from Rates data frame



test_that("2nd set of test for upfront", {
  
  data(rates, package = "CDS")
  
  x.1 <- data.frame(date = c(as.Date("2014-04-15"), as.Date("2014-04-22")),  
                    tenor = c(5, 5), 
                    coupon = c(500, 100), 
                    spread = c(2785.8889, 99),
                    currency = c("EUR", "EUR"),
                    recovery = c(0.4, 0.4))
  
  x.2 <- data.frame(date = c(as.Date("2014-04-15"), as.Date("2014-04-22")),  
                    maturity = c(as.Date("2019-06-20"), as.Date("2019-06-20")), 
                    coupon = c(500, 100), 
                    spread = c(2785.8889, 99),
                    currency = c("EUR", "EUR"),
                    recovery = c(0.4, 0.4))
 
  result.1 <- upfront(x = x.1, rates = rates, tenor.var = "tenor")
  expect_that(round(result.1, -2), equals(c(4412500, round(-14368, -2))))
  
  result.2 <- upfront(x.2, rates, tenor = "tenor")
  expect_that(round(result.2, -2), equals(c(4412500, round(-14368, -2))))
})