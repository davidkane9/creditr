# test case for JPY.condition function

library(CDS)

## if the currency is not JPY, and the date is a workday, 
## two days should be added to TDate

expect_equal(JPY.condition(currency = "USD", TDate = as.Date("2014-03-18"), 
                           baseDate = as.Date("2014-03-20")), 
             as.Date("2014-03-20"))

## if the currency is JPY, and the date is a workday, 
## two days should be added to TDate

expect_equal(JPY.condition(currency = "JPY", TDate = as.Date("2014-03-18"), 
                           baseDate = as.Date("2014-03-20")), 
             as.Date("2014-03-20"))

## if the currency is JPY, and the date is a JP holiday and a Friday, 
## three days should be added to TDate
## (two days for skipping to next Monday and one day for the holiday). 
## 2009-03-20 is a Friday and JP holiday.

expect_equal(JPY.condition(currency = "JPY", TDate = as.Date("2009-03-20"), 
                           baseDate = as.Date("2009-03-22")), 
             as.Date("2009-03-23"))

## if the currency is JPY, and the date is a JP holiday and not a Friday, 
## one day should be added to TDate. (one day for the holiday)
## 2009-09-21 is a Monday and JP holiday.

expect_equal(JPY.condition(currency = "JPY", TDate = as.Date("2009-09-21"), 
                           baseDate = as.Date("2009-09-21")), 
             as.Date("2009-09-22"))