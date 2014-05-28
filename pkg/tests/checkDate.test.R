# test case for checkDate function
library(CDS)
expect_that(checkDate("2014-03-04"), prints_text("NA"))
expect_that(checkDate("2020-03-04"), prints_text("Trade date should not be in the future"))
expect_that(checkDate("1993-03-04"), prints_text("Trade date too early!"))
expect_that(checkDate("20140304"), prints_text("Input date invalid"))
