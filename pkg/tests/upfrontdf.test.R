##  test cases for upfrontdf  

library(CDS)

## retrieve interest rates from Rates data frame

data(rates, package = "CDS")

rates <- rates

## test case for Norske Skogindustrier and Chorus Ltd. Create a data frame with 
## information from these two CDSs repeated 5000 times each.

## x.1 <- data.frame(date = c(rep("2014-04-15", 10000), rep("2014-04-22", 10000)),  
##                tenor = c(rep(5, 10000), rep(5, 10000)), 
##                coupon = c(rep(500, 10000), rep(100, 10000)), 
##                spread = c(rep(2785.8889, 10000), rep(99, 10000)),
##                currency = c(rep("EUR", 10000), rep("EUR", 10000)))

## x.2 <- data.frame(date = c(rep("2014-04-15", 10000), rep("2014-04-22", 10000)),  
##                  maturity = c(rep("2019-06-20", 10000), rep("2019-06-20", 10000)), 
##                  coupon = c(rep(500, 10000), rep(100, 10000)), 
##                  spread = c(rep(2785.8889, 10000), rep(99, 10000)),
##                  currency = c(rep("EUR", 10000), rep("EUR", 10000)))

## save(x.1, x.2, file = "upfrontdf.test.RData")

load("upfrontdf.test.RData")

## match the results from upfrontdf.R with the actual result. Note that there was a marginal difference
## which required the results to be rounded off to the nearest whole number

result.1 <- upfrontdf(x.1, rates, tenor.var = "tenor")
expect_that(round(result.1, -2), equals(c(rep(4412500, 10000), rep(round(-14368, -2), 10000))))

result.2 <- upfrontdf(x.2, rates, tenor = "tenor")
expect_that(round(result.2, -2), equals(c(rep(4412500, 10000), rep(round(-14368, -2), 10000))))
