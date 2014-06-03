## CDS.R test case for Toys R Us Inc

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      tenor = "5Y",
##                      contract ="SNAC",
##                      parSpread = 1737.7289,
##                      upfront = 3237500, 
##                      IRDV01 = -648.12,
##                      price = 67.25,
##                      principal = 3275000,
##                      RecRisk01 = -30848.67, 
##                      defaultExpo = 2725000, 
##                      spreadDV01 = 1580.31, 
##                      currency = "USD",
##                      ptsUpfront = 0.3275, 
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 500,
##                      recoveryRate = 0.40,
##                      defaultProb = 0.7813,
##                      notional = 1e7)

## save(truth1, file = "CDS.ToysRUs.test.RData")

load("CDS.ToysRUs.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               tenor = "5Y",
               contract="SNAC",
               parSpread = 1737.7289,
               currency = "USD",
               coupon = 500,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
