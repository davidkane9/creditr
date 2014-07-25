##  test cases for upfrontdf  

library(CDS)

## retrieve interest rates from Rates data frame
data(Rates, package = "CDS")

rates = rates

## test case for upfrontdf for one row of data (for CDS 
## data frame of information (for: Xerox Corporation on 2014-04-22) 
## that we input into the upfront() function
  
##save(x.1, x.2, x.3, rates.1, rates.2, rates.3, truth.1, truth.2, truth.3, file="upfrontdf.test.RData")
##load("upfrontdf.test.RData")

x.1 <- data.frame(date = c("2014-04-22"), 
                  maturity = c("2019-06-20"), 
                  coupon = c(100), 
                  spread = c(105.8))

## actual upfront value for xerox for this day
truth.1 <- 18624

## upfront value calculated by upfront() function

result.1 <- upfrontdf(x.1, rates)

## test case passes when upfront is rounded off to the nearest whole number

expect_that(round(result.1), equals(round(truth.1)))


## test case for multiple rows of CDS data, using CDSs of:
## 1. Xerox Corporation on 2014-04-22
## 2. Caesars Entertainment Corporation
## 3. Radioshack
## 4. ToysRUs

x.2 <- data.frame(date = c("2014-04-22", "2014-04-15", "2014-04-15", "2014-04-15"),  
                  maturity = c("2019-06-20", "2019-06-20", "2019-06-20", "2019-06-20"), 
                  coupon = c(100, 500, 500, 500), 
                  spread = c(105.8, 12354.53, 9106.8084, 1737.7289))


## vector with 4 upfront values calculated using the upfrontdf() function
result.2 <- upfrontdf(x.2, rates)

## actual upfront values from markit.com
truth.2 <- c(18624, 5707438, 5612324, 3237500)

## Note: we have to round off results due to the marginal differences
expect_that(round(result.2, -1), equals(round(truth.2, -1)))

## test cases with EUR as currency, using CDSs of:
## 1. NorskeIndustrier
## 2. ElectroluxAB

x.3 <- data.frame(date = c("2014-04-15", "2014-04-22"),  
                  maturity = c("2019-06-20", "2019-06-20"), 
                  coupon = c(500, 100), 
                  spread = c(2785.8889, 99))

## actual upfront values from markit.com
truth.3 <- c(4412500, -14368)

## vector with 2 upfront values calculated using the upfrontdf() function
result.3 <- upfrontdf(x.3, rates, currency="EUR")

## Note: test case passing only when rounded off to the nearest 100000
expect_that(round(result.3, -4), equals(round(truth.3, -4)))

## testing data frame with 10000 names
x.4 <- data.frame(date = c(rep("2014-04-15", 10000), rep("2014-04-22", 10000)),  
                  maturity = c(rep("2019-06-20", 10000), rep("2019-06-20", 10000)), 
                  coupon = c(rep(500, 10000), rep(100, 10000)), 
                  spread = c(rep(2785.8889, 10000), rep(99, 10000)),
                  currency = c(rep("EUR", 10000), rep("EUR", 10000)))

result.4 <- upfrontdf(x.4, rates, tenor = "tenor")
expect_that(result.4, equals(c(rep(4412560.33, 10000), rep(-14368.42, 10000))))
