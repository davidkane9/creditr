# test case for check.date function
library(CDS)

## if date is valid, it should return true
expect_that(check.date("2014-03-04"), equals(TRUE))

## if date is in the future, it should return false
expect_that(check.date("2020-03-04"), equals(FALSE))

## if TDate is before 1994
expect_that(check.date("1993-03-04"), equals(FALSE))

## if date format is not YYYY-MM-DD
expect_that(check.date("20140304"), equals(FALSE))

