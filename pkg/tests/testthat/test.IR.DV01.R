context("Test IR.DV01")

test_that("test for IR.DV01", {
  ## comparing IR.DV01 calculated by our package for Xerox Corp and Electrolux
  ## AB on April 22, 2014 with the results on Bloomberg
  
  x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
                  currency = c("USD", "EUR"),
                  tenor = c(5, 5),
                  maturity = c(NA, NA),
                  spread = c(105.8, 99),
                  coupon = c(100, 100),
                  recoveryRate = c(0.4, 0.4),
                  notional = c(1e7, 1e7))
  
  result <- IR.DV01(x)
  
  truth <- c(-7.36, 1.29)
  
  stopifnot(all.equal(round(result), round(truth)))
})
