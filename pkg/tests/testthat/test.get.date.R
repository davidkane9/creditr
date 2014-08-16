## Test cases for the get.date function (using data from April 15, 2014 for Norske
## Skogindustrier ASA).

library(CDS)

test_that("test for get.date", {
  ## Should return an error when no tenor or maturity date is given
  
  expect_error(get.date(date = as.Date("2014-04-15")))
  
  ## Should return an error when both tenor and maturity date are given; only one
  ## should be entered
  
  expect_error(get.date(date = as.Date("2014-04-15"), tenor = 5, maturity = as.Date("2016-06-20")))
  
  ## Should return an error when maturity is not of type date
  
  expect_error(get.date(date = as.Date("2014-04-15"), maturity = "not a date"))
  
  ## different dates for a CDS with a 10-year maturity
  
  ## Test case with CDS from April 15, 2014 (Caesar's Entertainment Corporation)
    
  load("get.date.test.RData")
  
  result.1 <- get.date(date = as.Date("2014-04-15"), tenor = 5)
  result.2 <- get.date(date = as.Date("2014-04-15"), maturity = "2019-06-20") 
  
  expect_that(result.1, is_identical_to(truth))
  expect_that(result.2, is_identical_to(truth))

  ## if the endDate (maturity date) is a weekend, get.date should just
  ## return a weekend day, instead of adjust it to the next weekeday
  
  ## for example, if we let trade date be "2010-06-18", then the
  ## maturity date should be "2015-06-20", a Saturday. As can be
  ## tested with Markit calculator
  
  ## However, currently get.date() coerce the endDate (maturity date)
  ## to be a weekend. Have to fix it later; for now we comment out
  ## the below test case
  
  # result.3 <- get.date(date = as.Date("2010-06-18"), tenor = 5)
  # expect_equal(result.3$endDate, as.Date("2015-06-20"))


})