context("Test update")

## test case for update using CDS of Xerox

test_that("test for spread", {
   ## object of class CDS
   object <- CDS(date = as.Date("2014-04-22"),
                tenor = 5, 
                spread = 105.8,
                coupon = 100,
                recovery.rate = 0.4,
                notional = 1e7)
   ## old upfront value from Markit.com, with spread 105.8
   
   oldUpf <- 18623.77
   
   ## new upfront value from Markit.com, with spread 155.8
   
   newUpf <- 254985.2
  
   ## save(object, oldUpf, newUpf, file="update.test.RData")

   ## new upfront values of update function
  
   result <- update(object, spread = 155.8)@upfront
  
   ## comparing new upfront values of update function with new upfront values from markit.com
  
   expect_that(round(result, -1), equals(round(newUpf, -1)))
})