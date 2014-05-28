## Test cases for the getDates function (using data from April 15, 2014 for Norske
## Skogindustrier ASA).

library(CDS)

expect_error(getDates(TDate = as.Date("2014-04-15")))
expect_error(getDates(TDate = as.Date("2014-04-15"), tenor = "5Y", maturity = as.Date("2016-06-20")))
expect_error(getDates(TDate = as.Date("2014-04-15"), maturity = "not a date"))

## different dates for a CDS with a 10-year maturity

## Where does this test case come from?

truth <- data.frame(TDate = as.Date("2014-04-15"), stepinDate = as.Date("2014-04-16"), 
           valueDate = as.Date("2014-04-18"), startDate = as.Date("2014-03-20"), 
           firstcouponDate = as.Date("2014-06-20"),
           pencouponDate=as.Date("2019-03-20"), endDate = as.Date("2019-06-20"), 
           backstopDate = as.Date("2014-02-14"))

result.1 <- getDates(TDate = as.Date("2014-04-15"), tenor = "5Y")

expect_that(result.1, is_identical_to(truth))

result.2 <- getDates(TDate = as.Date("2014-04-15"), maturity = "2014-04-15") 
## expect_that(result.2, is_identical_to(truth))
