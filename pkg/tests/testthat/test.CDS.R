## result.1 match:
## spreadDV01

## result.2 match:
## IRDV01, price, defaultExpo, spreadDV01

## result.3 match:
## everything except RecRisk01

## result.4 match:
## ptsUpfront, spreadDV01

context("Test CDS")

## CDS.R test case for Caesars Entertainment Operating Co Inc using data obtainined from Bloomberg.
## The .png files containing these results are in tests/sources

data(rates)

## we use rates for the relevant date and currency, extracted from the rates data frame, stored in the data 
## directory. 

test_that("test for the CDS", {
  
  ## rel.diff is a function which determines if the relative difference
  ## between the first argument (benchmark) and the second (real) is within
  ## a designated acceptable range (range).
  
  rel.diff <- function(benchmark,
                       real,
                       range = 0.01){
    if(abs(real - benchmark) / benchmark < range){
      return (TRUE)
    } else{
      return (FALSE)
    }
  }
  
  result.1 <- CDS(date = as.Date("2014-04-15"),
                  currency = "USD",
                  maturity = as.Date("2019-06-20"),                    
                  spread = 12354.529,
                  coupon = 500,
                  recovery.rate = 0.4,
                  notional = 1e7)
  
  ## check to see if our calcualted results are within an acceptable range
  ## of the true values from Bloomberg
 
  expect_true(rel.diff(5707438, result.1@upfront))
  
  expect_true(rel.diff(-271.18, result.1@IRDV01))
  
  expect_true(rel.diff(42.55, result.1@price))
  
  expect_true(rel.diff(5744938, result.1@principal))
  
  expect_true(rel.diff(-95430.32, result.1@RecRisk01))
  
  expect_true(rel.diff(255062, result.1@defaultExpo))
  
  expect_true(rel.diff(21.15, result.1@spreadDV01))
  
  
  ## CDS.R test case for Chorus Ltd. (Australian company)
  
  result.2 <- CDS(date = as.Date("2014-04-15"),
                  currency = "USD",                    
                  maturity = as.Date("2019-06-20"),                    
                  spread = 243.28,
                  coupon = 100,
                  recovery.rate = 0.40,
                  notional = 1e7)
  
  ## comparing results with true values from Bloomberg
  ## The results have to be rounded off as there are marginal differences
  
  expect_equal(round(650580), round(result.2@upfront))
  
  expect_equal(round(-169.33, 1), round(result.2@IRDV01, 1))
  
  expect_equal(93.42, round(result.2@price, 2))
  
  expect_equal(round(658080), round(result.2@principal))
  
  expect_equal(round(-1106.34, -2), round(result.2@RecRisk01, -2))
  
  expect_equal(round(5341920), round(result.2@defaultExpo))
  
  expect_equal(round(4317.54), round(result.2@spreadDV01))

  
  
  ## CDS.R test case for Electrolux AB corporation
  
  result.3 <- CDS(date = as.Date("2014-04-22"),
                  tenor = 5,
                  spread = 99,
                  contract ="STEC",
                  currency="EUR",
                  coupon = 100,
                  recovery.rate = 0.4,
                  notional = 1e7)
  
  ## comparing results with true values from Bloomberg
  ## The results have to be rounded off as there are marginal differences 
  
  ## Bloomberg rounds its upfront value of to the nearest whole number, so 
  ## we have to do the same
  expect_equal(round(-14368), round(result.3@upfront))
  
  expect_equal(round(1.29, 1), round(result.3@IRDV01, 1))
  
  expect_equal(100.05, round(result.3@price, 2))
  
  expect_equal(round(-4924), round(result.3@principal))
  
  expect_equal(round(3.46, 1), round(result.3@RecRisk01, 1))
  
  expect_equal(6004924, result.3@defaultExpo)
  
  expect_equal(round(4923.93), round(result.3@spreadDV01))

  
  ## CDS.R test case for Norske Skogindustrier ASA (European company)
  
  result.4 <- CDS(date = as.Date("2014-04-15"),
                  tenor = 5,
                  spread = 2785.8889,
                  contract ="STEC",
                  currency="EUR",
                  coupon = 500,
                  recovery.rate = 0.4,
                  notional = 1e7)
  
  ## comparing results with true values from Bloomberg
  ## The results have to be rounded off as there are marginal differences
  
  expect_equal(round(4412500, -2), round(result.4@upfront, -2))
  
  expect_equal(round(-727.47), round(result.4@IRDV01))
  
  expect_equal(55.5, round(result.4@price, 1))
  
  expect_equal(round(4450000, -3), round(result.4@principal, -3))
  
  expect_equal(round(-56413.77, -4), round(result.4@RecRisk01, -4))
  
  expect_equal(round(1550000, -3), round(result.4@defaultExpo, -3))
  
  expect_equal(round(731.48), round(result.4@spreadDV01))

  
  ## CDS.R test case for RadioShack Corp
  
  result.5 <- CDS(date = as.Date("2014-04-15"),
                  currency = "USD",                     
                  maturity = as.Date("2019-06-20"),
                  spread = 9106.8084,
                  coupon = 500,
                  recovery.rate = 0.4,
                  notional = 1e7)
  
  ## comparing results with true values from Bloomberg
  ## The results have to be rounded off as there are marginal differences
  
  expect_equal(round(5612324, -1),round(result.5@upfront, -1))
  
  expect_equal(round(-361.62, 0), round(result.5@IRDV01, 0))
  
  expect_equal(43.5, round(result.5@price, 1))
  
  expect_equal(round(5649824, -1), round(result.5@principal, -1))
  
  expect_equal(round(-93430.52, -3), round(result.5@RecRisk01, -3))
  
  expect_equal(round(350176, -1), round(result.5@defaultExpo, -1))
  
  expect_equal(round(40.86, 1), round(result.5@spreadDV01, 1))
  
  
  ## CDS.R test case for Tokyo Electric Power Co. Inc.
  
  result.6 <- CDS(date = as.Date("2014-04-15"),
                  tenor = 5,
                  contract ="STEC",
                  spread = 250,
                  currency = "JPY",
                  coupon = 100,
                  recovery.rate = 0.35,
                  notional = 1e7)
  
  ## comparing result.6 with true values from Bloomberg
  ## The result.6 have to be rounded off as there are marginal differences
  
  expect_equal(round(701502, -1), round(result.6@upfront, -1))
  
  expect_equal(round(-184.69), round(result.6@IRDV01))
  
  expect_equal(92.91, round(result.6@price, 2))
  
  expect_equal(round(709002, -1), round(result.6@principal, -1))
  
  expect_equal(round(-1061.74, -2), round(result.6@RecRisk01, -2))
  
  expect_equal(round(5790998, -1), round(result.6@defaultExpo, -1))
  
  expect_equal(round(4448.92), round(result.6@spreadDV01))
  
  
  ## CDS.R test case for Toys R Us Inc
  
  result.7 <- CDS(date = as.Date("2014-04-15"),
                  tenor = 5,
                  contract="SNAC",
                  spread = 1737.7289,
                  currency = "USD",
                  coupon = 500,
                  recovery.rate = 0.40,
                  notional = 1e7)
  
  ## comparing results with true values from Bloomberg
  ## The results have to be rounded off as there are marginal differences
  
  expect_equal(round(3237500), round(result.7@upfront))
  
  expect_equal(round(-648.12), round(result.7@IRDV01))
  
  expect_equal(round(67.25), round(result.7@price))
  
  expect_equal(round(3275000), round(result.7@principal))
  
  expect_equal(round(-30848.67, -3), round(result.7@RecRisk01, -3))
  
  expect_equal(round(2725000), round(result.7@defaultExpo))
  
  expect_equal(round(1580.31), round(result.7@spreadDV01))
  
  ## CDS.R test case for Xerox corporation
  
  result.8 <- CDS(date = as.Date("2014-04-22"),
                  tenor = 5,
                  spread = 105.8,
                  coupon = 100,
                  recovery.rate = 0.4,
                  notional = 1e7)
  
  ## comparing results with true values from Bloomberg
  ## The results have to be rounded off as there are marginal differences
  
  expect_equal(round(18624), round(result.8@upfront))
  
  expect_equal(round(-7.36, 1), round(result.8@IRDV01, 1))
  
  expect_equal(round(99.71931785,2), round(result.8@price, 2))
  
  expect_equal(round(28068), round(result.8@principal))
  
  expect_equal(round(-20.85), round(result.8@RecRisk01))
  
  expect_equal(round(5971932), round(result.8@defaultExpo))
  
  expect_equal(round(4825.49, 2), round(result.8@spreadDV01, 2))}
)