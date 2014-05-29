#  test cases for upfrontdf  

library(CDS)

# test case for upfrontdf for one row of data (for CDS 
# data frame of information (for Xerox Corporation on 2014-04-22) 
# that we input into the upfront() function
X <- data.frame(date = c("2014-04-22"), maturity = "5Y", 
                notional = c(1e7), coupon = c(100), currency = c("USD"), 
                spread = c(105.8))

# actual upfront value for xerox for this day
xeroxUpf <- 18624

result.1 <- upfrontdf(X)

expect_that(round(result.2, -1), equals(round(xeroxUpf, -1)))