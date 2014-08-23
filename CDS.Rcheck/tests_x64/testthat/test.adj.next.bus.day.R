context("Test adj.next.bus.day")

test_that("test adj.next.bus.day", {
  
  ## Friday test case
  
  date1 <- as.Date("2014-08-15")
  expect_that(adj.next.bus.day(date1), equals(as.Date("2014-08-15")))
  
  ## Saturday test case
  
  date2 <- as.Date("2014-08-16")
  expect_that(adj.next.bus.day(date2), equals(as.Date("2014-08-18")))
  
  ## Sunday test case
  
  date3 <- as.Date("2014-08-17")
  expect_that(adj.next.bus.day(date3), equals(as.Date("2014-08-18")))
  
  ## Monday test case
  
  date4 <- as.Date("2014-08-18")
  expect_that(adj.next.bus.day(date4), equals(as.Date("2014-08-18")))
})