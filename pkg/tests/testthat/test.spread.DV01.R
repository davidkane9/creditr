context("Test spread.DV01")

## SpreadDV01.test.R using CDS data for Xerox Corp on April 22, 2014

test_that("test for spread.DV01", {
  ## actual spread for Xerox
   truth.1 <- 4825.49
  
  ## save(truth.1, file = "spread.DV01.test.RData")
  
  
  
  x <- data.frame(date = as.Date("2014-04-22"),
                  currency = "USD",
                  maturity = NA,
                  tenor = 5,
                  spread = 105.8,
                  coupon = 100,
                  recoveryRate = 0.4,
                  notional = 1e7)
  
  result.1 <- spread.DV01(x)
  
  ## test case passes when results are rounded to the nearest whole number
  
  stopifnot(all.equal(round(result.1), round(truth.1)))
  
})
