## test case for check.Rates.Dates
library(CDS)

test_that("test for check.Rates.Dates", {
  ## the datframe 'rates' below does not contain the dates for the CDSs in data frane X.
  ## we will therefore expect an error
  
  ## X <- data.frame(date = c("2014-04-15", "2014-04-22"),  
  ##                  maturity = c("2019-06-20", "2019-06-20"), 
  ##                  coupon = c(500, 100), 
  ##                  spread = c(2785.8889, 99))
  
  ## rates data frame using getRatesdf
  ## rates <- get.rates.DF("2013-04-14", 
     ##                   "2013-04-16",
     ##                  currency = "EUR")
  
  ## save(X, rates, file = "check.rates.dates.test.RData")
  
  ## load("check.rates.dates.test.RData")
  ## result <- check.rates.dates(X, rates)
  
  ## false is contained in the vector returned by the function
  
  ## stopifnot(FALSE %in% result)
})
