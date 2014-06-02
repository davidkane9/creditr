## test case for check.Rates.Dates
library(CDS)
##
## the datframe 'rates' below does not contain the dates for the CDSs in data frane X.
## we will therefore expect an error

## X <- data.frame(date = c("2014-04-15", "2014-04-22"),  
##                  maturity = c("2019-06-20", "2019-06-20"), 
##                  coupon = c(500, 100), 
##                  spread = c(2785.8889, 99))

## rates data frame using getRatesdf
## rates <- getRatesDf("2013-04-14", 
##                      "2013-04-16",
##                      currency = "EUR")

## save(X, rates, file = "check.Rates.Dates.test.RData")
load("check.Rates.Dates.test.RData")
result <- check.Rates.Dates(X, rates)
## false is contained in the vector returned by the function
stopifnot(FALSE %in% result)
