context("Test build.rates") 

test_that("build.rates will fail if input is not of the correct type", {
  
  ## if the start.date or end.date is not Date type, there should be an error
  
  expect_error(build.rates(start.date = "2014-08-22", 
                           end.date = "2014-08-23"))
})