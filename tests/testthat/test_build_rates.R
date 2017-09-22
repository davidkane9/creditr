context("Test build_rates") 

test_that("build_rates will fail if input is not of the correct type", {
  
  ## if the start.date or end.date is not Date type, there should be an error
  
  expect_error(build_rates(start.date = "2014-08-22", 
                           end.date = "2014-08-23"))
})


test_that("start date shouldn't be later than end date", {
  expect_error(build_rates(start.date = as.Date("2014-08-22"), 
                           end.date = as.Date("2014-08-21")))
})

test_that("build_rates will fail if either input is a vector", {
  
  # Actually running the function with a vector will result in a fatal crash for R.
  # This should be a gentler stop.
  
  expect_error(build_rates(start.date = c(as.Date("2005-01-01"), as.Date("2005-02-01")), 
                           end.date = "2014-08-23"))
  
  expect_error(build_rates(start.date = as.Date("2014-08-22"), 
                           end.date = c(as.Date("2005-02-01"), as.Date("2005-03-01"))))
  
  expect_error(build_rates(start.date = c(as.Date("2005-01-01"), as.Date("2005-02-01")), 
                           end.date = c(as.Date("2005-02-01"), as.Date("2005-03-01"))))
  
})
