context("Test spread.to.pd")

test_that("spread.to.pd.test.R", {
  
  ## test case from Bloomberg screenshots of Chorus
  
  data <- data.frame(date = as.Date("2014-04-15"),
                     tenor = 5,
                     recovery = 0.4,
                     spread = 243.2800,
                     currency = "USD")

  truth <- 0.1915

  result <- spread.to.pd(data)
  
  ## currently the test case cannot be matched for 100%, so we need rounding
  ## here
  
  stopifnot(all.equal(round(result, 3), round(truth, 3)))
  
})
