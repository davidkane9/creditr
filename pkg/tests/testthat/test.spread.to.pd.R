library(CDS)


test_that("spread.to.pd.test.R", {
  
   truth <- spread.to.pd(spread = 32, time = 5.25, recovery.rate = 0.4)
  
  ## save(truth, file = "spread.to.pd.test.RData")
  
  
  result <- spread.to.pd(spread = 32, time = 5.25, recovery.rate = 0.4)
  
  stopifnot(all.equal(result, truth))
  
})
