context("Test values in rates data frame")

data(rates)

test_that("test that rates data frame has correct variable names and types", {
  
  expect_equal(names(rates), c("date", "currency", "expiry", "rates"))
  expect_equal(unname(sapply(rates, class)), c("Date", "factor", "factor", "numeric"))  

})

test_that("test that rates data frame variables currency and expiry have only allowed values", {
  
  expect_true(all(rates$currency %in% c("USD", "JPY", "EUR", "GBP")))
  
  expect_true(all(rates$expiry %in% c("1M", "2M", "3M", "6M", "9M",
                                      "1Y", "2Y", "3Y", "4Y", "5Y",  
                                      "6Y", "7Y", "8Y", "9Y",
                                      "10Y", "12Y", "15Y", "20Y", "25Y", "30Y")))
  
  
})

## labor day test case

## a random weekend all currency
