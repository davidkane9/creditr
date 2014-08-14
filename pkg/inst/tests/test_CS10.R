## test case for CS10, for CDS of Xerox corporation

library(CDS)

test_that("test case for CS10", {
  x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
                  currency = c("USD", "EUR"),
                  tenor = c("5Y", "5Y"),
                  maturity = c(NA, NA),
                  spread = c(105.8, 99),
                  coupon = c(100, 100),
                  recoveryRate = c(0.4, 0.4),
                  notional = c(1e7, 1e7))
  
  result <- IR.DV01(x)
  ## we don't have any thing to test this against at the moment
})

