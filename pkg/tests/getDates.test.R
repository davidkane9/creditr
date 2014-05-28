## test case for getDates function

library(CDS)
## different dates for a CDS with a 10-year maturity
truth1 <- data.frame(TDate = as.Date("2014-04-15"), stepinDate = as.Date("2014-04-16"), 
           valueDate = as.Date("2014-04-18"), startDate = as.Date("2014-03-20"), 
           firstcouponDate = as.Date("2014-06-20"),
           pencouponDate=as.Date("2019-03-20"), endDate = "2019-06-20", 
           backstopDate = as.Date("2014-02-14"))
result1 <- getDates(TDate = as.Date("2014-04-15"), maturity="5Y")
stopifnot(all.equal(truth1, result1))

expect_that(result1, is_identical_to(truth1))
