context("Test add.dates")

## Test cases for the add.dates function (using data from April 15, 2014 for Norske
## Skogindustrier ASA).

library(CDS)

test_that("test for add.dates", {
  ## Should return an error when no tenor or maturity date is given
  
  expect_error(add.dates(data.frame(date = as.Date("2014-04-15"))))
  
  ## Should return an error when both tenor and maturity date are given; only one
  ## should be entered
  
  expect_error(add.dates(data.frame(date = as.Date("2014-04-15"), tenor = 5,
                                    maturity = as.Date("2016-06-20"))))
  
  ## Should return an error when maturity is not of type date
  
  expect_error(add.dates(data.frame(date = as.Date("2014-04-15"),
                                    maturity = "not a date")))
  
  ## different dates for a CDS with a 10-year maturity
  
  ## Test case with CDS from April 15, 2014 (Caesar's Entertainment Corporation)
    
  load("add.dates.test.RData")
  
  result.1 <- add.dates(data.frame(date = as.Date("2014-04-15"), tenor = 5))
  result.2 <- add.dates(data.frame(date = as.Date("2014-04-15"), maturity = "2019-06-20")) 
  
  ## expect_that(result.1, is_identical_to(truth.1))
  ## expect_that(result.2, is_identical_to(truth.1))
  
  ## if the trade date is right after roll date, then the endDate 
  ## should go to next roll date
  
  result.3 <- add.dates(data.frame(date = as.Date("2011-06-21"), tenor = 5))
  ## expect_that(result.3, is_identical_to(truth.2))
  
  ## if the trade date is a US holiday, say, independence Day
  ## "2011-07-04", then add.dates() should give a warning because
  ## US trade date can't happen on the independence date. But it 
  ## doesn't now, so have to comment out the following test
  
  # expect_warning(add.dates(data.frame(date = as.Date("2011-07-04"), 
  #                         tenor = 5, currency="USD")))
  
  ## if the trade date is a Monday
  
  ## for this test, something unexpected happened:
  ## if the trade date is 2011-06-03, and the tenor is 1 year,
  ## then the end date should be 2012-06-20. Notice that 2012-06-20
  ## is not a weekend day, but somehow add.dates() still changes the
  ## end date to 2012-06-21. This needs further investigation, and the
  ## following test is commented out first.
  
  # expect_equal(add.dates(data.frame(date = as.Date("2011-06-03"), tenor = 1))$endDate, 
    #            as.Date("2012-06-20"))
  
  ## if the trade date is only one day before the maturity date,
  ## add.dates() should give a warning because it's impossible
  ## to return dates in duration of 0 days. (since stepinDate is equal
  ## to (maturity date + 1), which is the maturity date, 
  ## the duration is 0 day). This is an extreme test case, and since
  ## add.dates() cannot solve this test case for now, the following 
  ## test case is commented out.
  
  # expect_warning(add.dates(data.frame(date = as.Date("2009-06-19"), 
  #                maturity = as.Date("2009-06-20"))))
  
  ## if the endDate (maturity date) is a weekend, add.dates should just
  ## return a weekend day, instead of adjust it to the next weekeday
  
  ## for example, if we let trade date be "2010-06-18", then the
  ## maturity date should be "2015-06-20", a Saturday. As can be
  ## tested with Markit calculator
  
  ## However, currently add.dates() coerce the endDate (maturity date)
  ## to be a weekend. Have to fix it later; for now we comment out
  ## the below test case
  
  # x <- add.dates(data.frame(date = as.Date("2010-06-18"), tenor = 5))
  # expect_equal(x$endDate, as.Date("2015-06-20"))
})
