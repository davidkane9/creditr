context("Test pd.to.spread") 

## testing results of our function against the results produced by Bloomberg

test_that("test for pd.to.spread", {
  data <- data.frame(date = c(as.Date("2014-04-15"), as.Date("2014-04-22"), as.Date("2014-04-15")),
                     tenor = c(5, 5, 5),
                     recovery = c(0.4, 0.4, 0.4),
                     pd = c(0.1915, 0.0827, 0.9128),
                     currency = "USD")
  
  truth <- c(243.28, 99, 2785)
  
  result <- pd.to.spread(data)
  
  expect_equal(round(result), round(truth))
  
})
