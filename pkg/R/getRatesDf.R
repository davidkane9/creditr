#' function that takes a data frame of dates and returns a data frame with the 
#' yields for different maturities. Note year must be entered as YYYY-MM-DD.
#' 
#' @param startDate date from when rate calculation starts
#' @param endDate date when rate calculation ends
#' @param currency for which rates are being calculated
#' @return dataframe containing the rates from everyday between and including
#' the start and end dates. Note: the date in the column does not refer to the
#' rates of that day but the date on which the CDS is being priced. So the 
#' corresponding rate is actually the rate of the previous day. Example: if the 
#' column reads 2014-04-22, the corresponding rates are actually for 2014-04-21.
#' 
getRatesDf <- function(startDate, endDate, currency="USD"){
  yearRates = NULL
  endDate = as.Date(endDate)
  startDate = as.Date(startDate)
  # start & end date must be valid
  expect_that(checkDate(startDate), prints_text("NA"))
  expect_that(checkDate(endDate), prints_text("NA"))
  # start date must be smaller than end date
  expect_that(endDate>startDate, prints_text("TRUE"))
  # year = 1900 + as.POSIXlt(date)$year 
  while(endDate>startDate){
    getRates <- getRates(date = endDate, currency=currency)[[1]]
    rates <- as.numeric(levels(getRates$rate))
    expiry <- getRates$expiry
    date <- rep(endDate, length(rates))
    thisCurrency <- rep(currency, length(rates))
    df <- data.frame(date, currency, expiry, rates)
    yearRates <- rbind(yearRates, df)
    endDate <- endDate - 1
    # year = 1900 + as.POSIXlt(date)$year
  }  
  return(yearRates)
}


