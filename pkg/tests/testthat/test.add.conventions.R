context("Test illegal input to add.conventions")

test_that("error should occur if there is no currency.var ",{
  
  x <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")))
  expect_error(add.conventions(x))
  })

context("Test add.conventions")

test_that("test add conventions", {
  
  ## used independently
  
  x1 <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")), currency = c("USD", "JPY"))
  result1 <- add.conventions(x1)
  
  ## joint usage with add.dates
  
  x2 <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
                  currency = c("USD", "EUR"),
                  tenor = c(5, 5),
                  spread = c(120, 110),
                  coupon = c(100, 100),
                  recovery = c(0.4, 0.4),
                  notional = c(1e7, 1e7))
  
  x2 <- add.dates(x2)
  result2 <- add.conventions(x2)
  })