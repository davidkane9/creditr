library(utils)

## use capture.output to test the show() method

test_that("test show() method", {
  
  cds <- CDS(TDate = as.Date("2014-05-07"), tenor = 5, parSpread = 50, coupon = 100)
  
  output <- capture.output(show(cds))
  
  expect_that(output[1], equals("CDS Contract "))
  
  expect_that(output[2], equals(paste("Contract Type:                     ",
                                      cds@contract,
                                      "  Currency:                        ",
                                      cds@currency)))
  
  expect_that(output[3], equals(paste("Entity Name:                         ",
                                      cds@entityName,
                                      "  RED:                              ",
                                      cds@RED)))
  
  expect_that(output[4], equals(paste("TDate:                       ",
                                      cds@TDate,
                                      "  End Date:                 ",
                                      cds@endDate)))
  
  expect_that(output[5], equals(paste("Start Date:                  ",
                                      cds@startDate,
                                      "  Backstop Date:            ",
                                      cds@backstopDate)))
  
  expect_that(output[6], equals(paste("1st Coupon:                  ",
                                      cds@firstcouponDate,
                                      "  Pen Coupon:               ",
                                      cds@pencouponDate)))
  
  expect_that(output[7], equals(paste("Day Cnt:                        ",
                                      cds@dccCDS,
                                      "  Freq:                              ",
                                      cds@freqCDS)))
  
  expect_that(output[8], equals(""))
  
  expect_that(output[9], equals("Calculation "))
  
  expect_that(output[10], equals(paste("Value Date:                  ",
                                       cds@valueDate,
                                       "  Price:                        ",
                                       round(cds@price, 2))))
  
  expect_that(output[11], equals(paste("Spread:                              ",
                                       cds@parSpread,
                                       "  Pts Upfront:                 ",
                                       round(cds@ptsUpfront, 4))))
  
  ## Actually, hard coding doesn't matter here since we are dealing with this
  ## specific case.
  
  ## All we have to make sure is that after we redesign the class these prints
  ## still look the same
  
  expect_that(output[12], equals("Principal:                      -246,036   Spread DV01:                    5,022"))
  
  expect_that(output[13], equals("Accrual:                         -13,611   IR DV01:                        64.44"))
  
  expect_that(output[14], equals("Upfront:                        -259,647   Rec Risk (1 pct):               87.88"))
  
  expect_that(output[15], equals("Default Prob:                     0.0424   Default Expo:               6,246,036"))
  
  expect_that(output[16], equals(""))
  
  expect_that(output[17], equals("Credit curve effective of 2014-05-07 "))
  
  expect_that(output[18], equals(" Term     Rate Term     Rate"))
  
  expect_that(output[19], equals("   1M 0.001505   7Y 0.022555"))
  
  expect_that(output[20], equals("   2M 0.001893   8Y 0.024350"))
  
  expect_that(output[21], equals("   3M 0.002249   9Y 0.025800"))
  
  expect_that(output[22], equals("   6M 0.003229  10Y 0.027045"))
  
  expect_that(output[23], equals("   1Y 0.005436  12Y 0.028995"))
  
  expect_that(output[24], equals("   2Y 0.005585  15Y 0.030945"))
  
  expect_that(output[25], equals("   3Y 0.010145  20Y 0.032625"))
  
  expect_that(output[26], equals("   4Y 0.014285  25Y 0.033390"))
  
  expect_that(output[27], equals("   5Y 0.017625  30Y 0.033740"))
  
  expect_that(output[28], equals("   6Y 0.020365              "))
  
  expect_that(output[29], equals(""))
}
  )
