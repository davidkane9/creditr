library(CDS)


test_that("defaultProb.test.R", {
  
  ## truth <- defaultProb(parSpread = 32, t = 5.25, recoveryRate = 0.4)
  
  ## save(truth, file = "default.prob.test.RData")
  
  load("default.prob.test.RData")
  
  result <- default.prob(parSpread = 32, t = 5.25, recoveryRate = 0.4)
  
  stopifnot(all.equal(result, truth))
  
})
