## CDS.R test case

library(CDS)

## truth.1 <- CDS(TDate = "2014-01-14",
##               tenor = "5Y",
##               parSpread = 32,
##               coupon = 100,
##               recoveryRate = 0.4,
##               isPriceClean = FALSE,
##               notional = 1e7)

## save(truth1, file = "CDS.test.RData")

## load("CDS.test.RData")

result.1 <- CDS(TDate = "2014-01-14",
               tenor = "5Y",
               parSpread = 32,
               coupon = 100,
               recoveryRate = 0.4,
               isPriceClean = FALSE,
               notional = 1e7)

stopifnot(all.equal(truth.1, result.1))

## if neither maturity date nor tenor are provided, function must return an error

expect_that(CDS(TDate = "2014-01-14",
                parSpread = 32,
                coupon = 100,
                recoveryRate = 0.4,
                isPriceClean = FALSE,
                notional = 1e7), throws_error())