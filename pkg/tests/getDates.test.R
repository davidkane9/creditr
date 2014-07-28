## Test cases for the getDates function (using data from April 15, 2014 for Norske
## Skogindustrier ASA).

library(CDS)

## Should return an error when no tenor or maturity date is given

expect_error(getDates(TDate = as.Date("2014-04-15")))

## Should return an error when both tenor and maturity date are given; only one
## should be entered

expect_error(getDates(TDate = as.Date("2014-04-15"), tenor = "5Y", maturity = as.Date("2016-06-20")))

## Should return an error when maturity is not of type date

expect_error(getDates(TDate = as.Date("2014-04-15"), maturity = "not a date"))

## different dates for a CDS with a 10-year maturity

## Test case with CDS from April 15, 2014 (Caesar's Entertainment Corporation)

## truth <- data.frame(TDate = as.Date("2014-04-15"), stepinDate = as.Date("2014-04-16"), 
##           valueDate = as.Date("2014-04-18"), startDate = as.Date("2014-03-20"), 
##           firstcouponDate = as.Date("2014-06-20"),
##           pencouponDate=as.Date("2019-03-20"), endDate = as.Date("2019-06-20"), 
##           backstopDate = as.Date("2014-02-14"))

## save(truth, file="getDates.test.RData")

load("getDates.test.RData")

result.1 <- getDates(TDate = as.Date("2014-04-15"), tenor = "5Y")
result.2 <- getDates(TDate = as.Date("2014-04-15"), maturity = "2019-06-20") 

expect_that(result.1, is_identical_to(truth))
expect_that(result.2, is_identical_to(truth))
