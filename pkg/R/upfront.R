#' Calculate Upfront Payments
#' 
#' \code{upfront} takes a dataframe of variables on CDSs to return a vector of
#' upfront values. Note that all CDS in the data frame must be denominated in 
#' the same currency.
#' 
#' @inheritParams CS10
#' @param rates is an array of numeric values indicating the rate of
#'        each instrument.
#' @param notional is the amount of the underlying asset on which the
#'        payments are based. Default is 1e7, i.e. 10MM.
#' @param date.var name of column in x containing dates when the trade 
#'        is executed, denoted as T. Default is \code{Sys.Date}  + 2 weekdays.
#' @param spread.var name of column in x containing  par spreads in bps.
#' @param recovery.var f column in x containing recovery 
#'        rates in decimal.
#' @param isPriceClean refers to the type of upfront calculated. It is
#'        boolean. When \code{TRUE}, calculate principal only. When
#'        \code{FALSE}, calculate principal + accrual.
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
  
  x <- add.conventions(x)
  
  for(i in 1:nrow(x)){
    
    rates <- copy
    
    ## subset out the rates of the relevant currency
    
    ## change expiries depending on currency
    ## feeding in expiries, types (and rates) instead of extracting from getRates saves time as
    ## getRates would download the data from the internet
    
    
    expiries <- get.rates(date = x[[date.var]][i], currency = x[[currency.var]][[i]])$expiry
    types <-  paste(as.character(get.rates(date = x[[date.var]][i],
                                           currency = x[[currency.var]][[i]])$type), collapse = "")
    mmDCC <- x$mmDCC 
    fixedSwapFreq <- x$fixedFreq 
    floatSwapFreq <- x$floatFreq
    fixedSwapDCC <- x$fixedDCC
    floatSwapDCC <- x$floatDCC 
    badDayConvZC <- x$badDayConvention  
    holidays <- "NONE"
    calendar <- "NONE"
    
    ## if tenor is just a number i.e. written as just 5, then we turn it to the string "5Y"
    
    if(!is.null(x[[tenor.var]])) {  ## if tenor is provided
      x[i, tenor.var] <- as.numeric(x[i, tenor.var])      
      tenor <- x[i, tenor.var]
    } else {
      tenor <- NULL
    }
    
    date <- x[i, date.var]
    currency <- x[i, currency.var]
    rates <- rates$rates[rates$date == as.Date(x[i,date.var]) & 
                           rates$currency == as.character(x[i, currency.var])]                                     
    valueDate <- NULL
    benchmarkDate <- NULL
    startDate <- NULL
    endDate <- NULL
    stepinDate <- NULL
    maturity <- x[i, maturity.var]
    dccCDS <- "ACT/360"
    freqCDS <- "1Q"
    stubCDS <- "F"
    badDayConvCDS <- "F"
    spread <- x[i, spread.var]
    coupon <- x[i, coupon.var]
    recovery.rate <- x[i, recovery.var]
    isPriceClean <- isPriceClean
    payAccruedOnDefault <- TRUE
    
    ## stop if date is invalid
    
    date <- as.Date(date)
    
    ## basedate is T + 2 weekdays .    
    
    if(as.POSIXlt(date)$wday==5){
      baseDate <- adj.next.bus.day(date+4)
    } else if(as.POSIXlt(date)$wday==0){
      baseDate <- adj.next.bus.day(date+3)
    } else {
      baseDate <- adj.next.bus.day(date+2)
    }
    
    ## for JPY, the baseDate is date + 2 bus days, whereas for the rest it is date + 2 weekdays
    
    baseDate <- JPY.condition(baseDate = baseDate, date = date, currency = currency)
    
    ## rates Date is the date for which interest rates will be calculated. get.rates 
    ## function will return the rates of the previous day
    
    ratesDate <- as.Date(date)
    
    ## if maturity date is not provided, we use tenor to obtain dates through
    ## add.dates, and vice versa.
    
    if(is.null(tenor)){
      cdsDates <- add.conventions(add.dates(data.frame(date = as.Date(date),
                                                       maturity = as.Date(maturity),
                                                       currency = currency)))
    }
    else if(is.null(maturity)){
      cdsDates <- add.conventions(add.dates(data.frame(date = as.Date(date), tenor = tenor,
                                                       currency = currency)))
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
      effectiveDate <- adj.next.bus.day(date)
      
      ## extract relevant variables like mmDCC, expiries from the get.rates function 
      ## if they are not entered
      
      if (is.null(types)) types       <- paste(as.character(ratesInfo$type), collapse = "")
      if (is.null(rates)) rates       <- as.numeric(as.character(ratesInfo$rate))
      if (is.null(expiries)) expiries <- as.character(ratesInfo$expiry)
      if (is.null(mmDCC)) mmDCC       <- as.character(cdsDates$mmDCC)
      
      if (is.null(fixedSwapFreq)) fixedSwapFreq <- as.character(cdsDates$fixedFreq)
      if (is.null(floatSwapFreq)) floatSwapFreq <- as.character(cdsDates$floatFreq)
      if (is.null(fixedSwapDCC)) fixedSwapDCC   <- as.character(cdsDates$fixedDCC)
      if (is.null(floatSwapDCC)) floatSwapDCC   <- as.character(cdsDates$floatDCC)
      if (is.null(badDayConvZC)) badDayConvZC   <- as.character(cdsDates$badDayConvention)
      if (is.null(holidays)) holidays           <- as.character(cdsDates$swapCalendars)
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
                        
                        todayDate_input = separate.YMD(date),
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
                        
                        parSpread = spread,
                        couponRate = coupon,
                        recoveryRate = recovery.rate,
                        isPriceClean_input = isPriceClean,
                        payAccruedOnDefault_input = payAccruedOnDefault,
                        notional = notional,
                        PACKAGE = "CDS")  
  } 
  
  return(results)
}