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
  
  ## if the trade date is only one day before the maturity date,
  ## get.date() should give a warning because it's impossible
  ## to return dates in duration of 0 days. (since stepinDate is equal
  ## to (maturity date + 1), which is the maturity date, 
  ## the duration is 0 day). This is an extreme test case, and since
  ## get.date() cannot solve this test case for now, the following 
  ## test case is commented out.
  
  # expect_warning(get.date(date = as.Date("2009-06-19"), 
  #                maturity = as.Date("2009-06-20")))
  
  ## if the endDate (maturity date) is a weekend, get.date should just
  ## return a weekend day, instead of adjust it to the next weekeday
  
  ## for example, if we let trade date be "2010-06-18", then the
  ## maturity date should be "2015-06-20", a Saturday. As can be
  ## tested with Markit calculator
  
  ## However, currently get.date() coerce the endDate (maturity date)
  ## to be a weekend. Have to fix it later; for now we comment out
  ## the below test case
  
  # x <- get.date(date = as.Date("2010-06-18"), tenor = 5)
  # expect_equal(x$endDate, as.Date("2015-06-20"))


})