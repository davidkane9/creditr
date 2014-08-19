#' Calculate Upfront Payments
#' 
#' \code{upfront} takes a dataframe of variables on CDSs to return a vector of
#' upfront values. Note that all CDS in the data frame must be denominated in 
#' the same currency.
#' 
#' @inheritParams CS10
#' @param rates is an array of numeric values indicating the rate of
#' each instrument.
#' @param notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' @param date.var name of column in x containing dates when the trade 
#' is executed, denoted as T. Default is \code{Sys.Date}  + 2 weekdays.
#' @param spread.var name of column in x containing  par spreads in bps.
#' @param recovery.var f column in x containing recovery 
#' rates in decimal.
#'
#' @return vector of upfront values (with accrual) in the same order

upfront <- function(x, 
                      rates, 
                      currency.var = "currency", 
                      notional = 1e7,
                      date.var = "date", 
                      spread.var = "spread",
                      coupon.var = "coupon",
                      tenor.var = "tenor",
                      maturity.var = "maturity",
                      recovery.var = "recovery",
                      isPriceClean = FALSE){
  
  stopifnot(! (is.null(x[[maturity.var]]) & is.null(x[[tenor.var]]))) ## stop if both are null
  stopifnot(   is.null(x[[maturity.var]]) | is.null(x[[tenor.var]])) ## stop if neither of them are NULL
  
  ## stop if not all the relevant variables are contained in x
  
  stopifnot(all(c(date.var, spread.var, coupon.var) %in% names(x)))
  
  ## stop if the relevant variables are not of the appropriate type 
  
  stopifnot(inherits(as.Date(x[[date.var]]), "Date"))
  if(!is.null(x[[maturity.var]])){
    stopifnot(inherits(as.Date(x[[maturity.var]]), "Date"))
  }
  stopifnot(inherits(as.character(x[[currency.var]]), "character"))
  
  stopifnot(is.numeric(notional))
  stopifnot(is.numeric(x[[coupon.var]]))
  
  ## stop if one of the dates in the X data frame does not have a corresponding
  ## interest rate curve in the rates data frame.
  
  # stopifnot(!(FALSE %in% check.Rates.Dates(x, rates)))  
  
  ## subset out the rates data frame to only include the dates between the oldest and
  ## latest date in the 'x' data frame.
  
  min.date <- min(as.Date(x[[date.var]]))
  max.date <- max(as.Date(x[[date.var]]))
  
  rates <- rates[rates$date >= min.date & rates$date <= max.date,]
  
  copy <- rates
  
  results <- rep(NA, nrow(x))
  
  for(i in 1:nrow(x)){
    
    rates <- copy
    
    ## subset out the rates of the relevant currency
    
    ## change expiries depending on currency
    ## feeding in expiries, types (and rates) instead of extracting from getRates saves time as
    ## getRates would download the data from the internet
    
    if(x[i, currency.var] == "USD"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y",
                    "10Y", "12Y", "15Y", "20Y", "25Y", "30Y")
      types <- "MMMMMSSSSSSSSSSSSSS"
      mmDCC <- "ACT/360" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "3M"
      fixedSwapDCC <- "30/360" 
      floatSwapDCC <- "ACT/360" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var] == "EUR"){
      expiries <- c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", 
                    "5Y", "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", 
                    "30Y")
      types <- "MMMMMMSSSSSSSSSSSSS"
      mmDCC <- "ACT/360" 
      fixedSwapFreq <- "1Y" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "30/360" 
      floatSwapDCC <- "ACT/360" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    } else if(x[i, currency.var] == "JPY"){
      expiries <- c("1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", 
                    "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "30Y")
      types <- "MMMMMSSSSSSSSSSSSS"
      mmDCC <- "ACT/360" 
      fixedSwapFreq <- "6M" 
      floatSwapFreq <- "6M"
      fixedSwapDCC <- "ACT/365" 
      floatSwapDCC <- "ACT/360" 
      badDayConvZC <- "M" 
      holidays <- "None"
      calendar <- "None"
    }
    
    ## if tenor is just a number i.e. written as just 5, then we turn it to the string "5Y"
    
    if(!is.null(x[[tenor.var]])) {  ## if tenor is provided
      x[i, tenor.var] <- as.numeric(x[i, tenor.var])      
      tenor <- x[i, tenor.var]
    } else {
     tenor <- NULL
    }
    
    TDate <- x[i, date.var]
    currency <- x[i, currency.var]
    types <- types
    rates <- rates$rates[rates$date == as.Date(x[i,date.var]) & 
                           rates$currency == as.character(x[i, currency.var])]
    expiries <- expiries                    
    mmDCC <- as.character(mmDCC)                    
    fixedSwapFreq <- as.character(fixedSwapFreq)
    floatSwapFreq <- as.character(floatSwapFreq)
    fixedSwapDCC <- as.character(fixedSwapDCC)
    floatSwapDCC <- as.character(floatSwapDCC)
    badDayConvZC <- as.character(badDayConvZC)
    holidays <- as.character(holidays)    
    valueDate <- NULL
    benchmarkDate <- NULL
    startDate <- NULL
    endDate <- NULL
    stepinDate <- NULL
    tenor <- tenor
    maturity <- x[i, maturity.var]
    dccCDS <- "ACT/360"
    freqCDS <- "1Q"
    stubCDS <- "F"
    badDayConvCDS <- "F"
    calendar <- calendar
    parSpread <- x[i, spread.var]
    coupon <- x[i, coupon.var]
    recoveryRate <- x[i, recovery.var]
    isPriceClean <- isPriceClean
    payAccruedOnDefault <- TRUE
    notional <- notional
    
    ## stop if TDate is invalid
    
    TDate <- as.Date(TDate)
    
    ## basedate is T + 2 weekdays .    
    
    if(as.POSIXlt(TDate)$wday==5){
     baseDate <- adj.next.bus.day(TDate+4)
    } else if(as.POSIXlt(TDate)$wday==0){
     baseDate <- adj.next.bus.day(TDate+3)
    } else {
     baseDate <- adj.next.bus.day(TDate+2)
    }
    
    ## for JPY, the baseDate is TDate + 2 bus days, whereas for the rest it is TDate + 2 weekdays
    
    baseDate <- JPY.condition(baseDate = baseDate, TDate = TDate, currency = currency)
    
    ## rates Date is the date for which interest rates will be calculated. get.rates 
    ## function will return the rates of the previous day
    
    ratesDate <- as.Date(TDate)
    
    ## if maturity date is not provided, we use tenor to obtain dates through
    ## add.dates, and vice versa.
    
    if(is.null(tenor)){
      cdsDates <- add.dates(data.frame(date = as.Date(TDate),
                                       maturity = as.Date(maturity)))
    }
    else if(is.null(maturity)){
      cdsDates <- add.dates(data.frame(date = as.Date(TDate), tenor = tenor))
    }
    
    ## if these dates are not entered, they are extracted using add.dates
    
    if (is.null(valueDate)) valueDate         <- cdsDates$valueDate
    if (is.null(benchmarkDate)) benchmarkDate <- cdsDates$startDate
    if (is.null(startDate)) startDate         <- cdsDates$startDate
    if (is.null(endDate)) endDate             <- cdsDates$endDate
    if (is.null(stepinDate)) stepinDate       <- cdsDates$stepinDate
    
    ## stop if number of rates != number of expiries != length of types
    
    stopifnot(all.equal(length(rates), length(expiries), nchar(types)))    
    
    ## if any of these three are null, we extract them using get.rates
    
    if ((is.null(types) | is.null(rates) | is.null(expiries))){
      
      ratesInfo <- get.rates(date = ratesDate, currency = currency)
      effectiveDate <- as.Date(as.character(ratesInfo[[2]]$effectiveDate))
      
      ## extract relevant variables like mmDCC, expiries from the get.rates function 
      ## if they are not entered
      
      if (is.null(types)) types       <- paste(as.character(ratesInfo[[1]]$type), collapse = "")
      if (is.null(rates)) rates       <- as.numeric(as.character(ratesInfo[[1]]$rate))
      if (is.null(expiries)) expiries <- as.character(ratesInfo[[1]]$expiry)
      if (is.null(mmDCC)) mmDCC       <- as.character(ratesInfo[[2]]$mmDCC)
      
      if (is.null(fixedSwapFreq)) fixedSwapFreq <- as.character(ratesInfo[[2]]$fixedFreq)
      if (is.null(floatSwapFreq)) floatSwapFreq <- as.character(ratesInfo[[2]]$floatFreq)
      if (is.null(fixedSwapDCC)) fixedSwapDCC   <- as.character(ratesInfo[[2]]$fixedDCC)
      if (is.null(floatSwapDCC)) floatSwapDCC   <- as.character(ratesInfo[[2]]$floatDCC)
      if (is.null(badDayConvZC)) badDayConvZC   <- as.character(ratesInfo[[2]]$badDayConvention)
      if (is.null(holidays)) holidays           <- as.character(ratesInfo[[2]]$swapCalendars)
    }
    
    
    results[i] <- .Call('calcUpfrontTest',
                        baseDate_input = separate.YMD(baseDate),
                        types = types,
                        rates = rates,
                        expiries = expiries,
                        
                        mmDCC = mmDCC,
                        fixedSwapFreq = fixedSwapFreq,
                        floatSwapFreq = floatSwapFreq,
                        fixedSwapDCC = fixedSwapDCC,
                        floatSwapDCC = floatSwapDCC,
                        badDayConvZC = badDayConvZC,
                        holidays = holidays,
                        
                        todayDate_input = separate.YMD(TDate),
                        valueDate_input = separate.YMD(valueDate),
                        benchmarkDate_input = separate.YMD(benchmarkDate),
                        startDate_input = separate.YMD(startDate),
                        endDate_input = separate.YMD(endDate),
                        stepinDate_input = separate.YMD(stepinDate),
                        
                        dccCDS = dccCDS,
                        ivlCDS = freqCDS,
                        stubCDS = stubCDS,
                        badDayConvCDS = badDayConvCDS,
                        calendar = calendar,
                        
                        parSpread = parSpread,
                        couponRate = coupon,
                        recoveryRate = recoveryRate,
                        isPriceClean_input = isPriceClean,
                        payAccruedOnDefault_input = payAccruedOnDefault,
                        notional = notional,
                        PACKAGE = "CDS")  
  } 
  
  return(results)
}