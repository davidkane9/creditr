#' \code{upfrontdf} takes a dataframe of variables on CDSs to return a vector of
#' upfront values. Note that all CDS in the data frame must be denominated in 
#' the same currency.
#' 
#' @param x dataframe containing variables date.var, spread.var, coupon.var and
#'   maturity.var.
#' @param rates dataframe containing dates and rates for those dates. Note that 
#'   the date column over here refers to the date for which the adjacent 
#'   interest rate curve would apply. So if it says "2014-07-25", the interest 
#'   rate curve is from "2014-07-24".
#' @param currency.var name of the column for currencies in the dataframe. 
#' @param notional values of CDSs in the dataframe. Defualt is 10 million.
#' @param date.var name of the column containing dates. By default is "date"
#' @param spread.var name of the column containing spreads. By default is 
#' "spread".
#' @param coupon.var name of the column containing the coupon rates. By default 
#' is "coupon"
#' @param recovery.var name of the column containing the recovery rates. By default 
#' is "recovery"
#' @param maturity.var name of the column containing the maturity dates (note: 
#' this is different from tenor i.e. it is a proper date like "2019-06-20" and
#' not "5Y"). By default is "maturity".
#' @param tenor.var name of the column containing the tenors of the CDS contracts.
#' Note that we can only provide either the tenor or the maturity date, not both.    
#' @param isPriceClean boolean to specify if you want the dirty upfront or the 
#' clean upfront (principal).
#'   
#' @return vector of upfront values (with accrual) in the same order

upfrontdf <- function(x, 
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
      x[i, tenor.var] <- as.character(x[i, tenor.var])      
      if(!grepl("Y", x[i, tenor.var])){
        x[i, tenor.var] <- paste(x[i, tenor.var], "Y", sep = "")
      }
      tenor <- x[i, tenor.var]
    } else {
      tenor <- NULL
    }
    
    TDate <- x[i, date.var]
    baseDate <- as.Date(TDate) + 2
    currency <- x[i, currency.var]
    types <- types
    rates <- rates$rates[rates$date == as.Date(x[i,date.var]) & rates$currency == as.character(x[i, currency.var])]
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
    
    stopifnot(check.date(TDate))
    
    TDate <- as.Date(TDate)
    
    if(as.POSIXlt(TDate)$wday==5){
      baseDate <- .adj.next.bus.day(TDate+4)
    } else if(as.POSIXlt(TDate)$wday==0){
      baseDate <- .adj.next.bus.day(TDate+3)
    } else {
      baseDate <- .adj.next.bus.day(TDate+2)
    }
    
    ## for JPY, the baseDate is TDate + 2 bus days, whereas for the rest it is TDate + 2 weekdays
    
    baseDate <- JPY.condition(baseDate = baseDate, TDate = TDate, 
                              currency = currency)
    
    ## rates Date is the date for which interest rates will be calculated. get.rates 
    ## function will return the rates of the previous day
    
    ratesDate <- as.Date(TDate)
    
    ## if maturity date is not provided, we use tenor to obtain dates through
    ## get.date, and vice versa.
    
    if(is.null(tenor)){
      cdsDates <- get.date(date = as.Date(TDate), maturity = as.Date(maturity), tenor = NULL)
    }
    else if(is.null(maturity)){
      cdsDates <- get.date(date = as.Date(TDate), maturity = NULL, tenor = tenor)
    }
    
    ## if these dates are not entered, they are extracted using get.date
    
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
    }
    
   
    results[i] <- .Call('calcUpfrontTest',
                        .separate.YMD(baseDate),
                        paste(as.character(ratesInfo[[1]]$type), collapse = ""),
                        as.numeric(as.character(ratesInfo[[1]]$rate)),
                        as.character(ratesInfo[[1]]$expiry),
                        
                        as.character(ratesInfo[[2]]$mmDCC),
                        as.character(ratesInfo[[2]]$fixedFreq),
                        as.character(ratesInfo[[2]]$floatFreq),
                        as.character(ratesInfo[[2]]$fixedDCC),
                        as.character(ratesInfo[[2]]$floatDCC),
                        as.character(ratesInfo[[2]]$badDayConvention),
                        "None",
                        
                        .separate.YMD(x[[TDate.var]][i]),
                        .separate.YMD(valueDate),
                        .separate.YMD(benchmarkDate),
                        .separate.YMD(startDate),
                        .separate.YMD(endDate),
                        .separate.YMD(stepinDate),
                        
                        "ACT/360",
                        "1Q",
                        "F",
                        "F",
                        "None",
                        
                        x[[parSpread.var]][i],
                        x[[coupon.var]][i],
                        x[[recoveryRate.var]][i],
                        isPriceClean,
                        payAccruedOnDefault,
                        x[[notional.var]][i],
                        PACKAGE = "CDS")
  } 
  
  return(results)
}