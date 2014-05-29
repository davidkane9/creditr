#  test cases for upfrontdf  

library(CDS)

# test case for upfrontdf for one row of data (for CDS 
# data frame of information (for Xerox Corporation on 2014-04-22) 
# that we input into the upfront() function

x <- data.frame(date = as.Date("2014-04-22"), maturity = as.Date("2019-06-20"), 
                coupon = c(100), spread = c(105.8))

expect_error(upfrontdf(x, notional = "not a number"))
expect_error(upfrontdf(x, currency = 100))


# actual upfront value is equal to the package's upfront value when rounded to the
# nearest 100.

xeroxUpf <- 18624 

result.1 <- upfrontdf(x, notional = c(1e7), currency = "USD")

expect_that(round(result.1, -2), equals(round(xeroxUpf, -2)))
