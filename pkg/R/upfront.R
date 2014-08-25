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
  
  stopifnot(!(is.null(x[[maturity.var]]) & is.null(x[[tenor.var]]))) ## stop if both are null
  stopifnot(is.null(x[[maturity.var]]) | is.null(x[[tenor.var]])) ## stop if neither of them are NULL
  
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
    
    if(!is.null(x[[tenor.var]])) {
      x[i, tenor.var] <- as.numeric(x[i, tenor.var])      
      tenor <- x[i, tenor.var]
    } else {
      tenor <- NULL
    }
  
    ## basedate is T + 2 weekdays .    
    
    if(as.POSIXlt(as.Date(x[i, date.var]))$wday==5){
      baseDate <- adj.next.bus.day(as.Date(x[i, date.var]) + 4)
    } else if(as.POSIXlt(as.Date(x[i, date.var]))$wday==0){
      baseDate <- adj.next.bus.day(as.Date(x[i, date.var]) + 3)
    } else {
      baseDate <- adj.next.bus.day(as.Date(x[i, date.var]) + 2)
    }
    
    ## for JPY, the baseDate is date + 2 bus days, whereas for the rest it is date + 2 weekdays
    
    baseDate <- JPY.condition(baseDate = baseDate, date = as.Date(x[i, date.var]),
                              currency = x[i, currency.var])
    
    ## if maturity date is not provided, we use tenor to obtain dates through
    ## add.dates, and vice versa.
    
    if(is.null(tenor)){
      cdsDates <- add.conventions(add.dates(data.frame(date = as.Date(x[i, date.var]),
                                                       maturity = as.Date(x[i, maturity.var]),
                                                       currency = x[i, currency.var])))
    }
    else if(is.null(x[i, maturity.var])){
      cdsDates <- add.conventions(add.dates(data.frame(date = as.Date(x[i, date.var]), tenor = tenor,
                                                       currency = x[i, currency.var])))
    }
     
    ratesInfo <- get.rates(date = as.Date(x[i, date.var]), currency = x[i, currency.var])
    
    results[i] <- .Call('calcUpfrontTest',
                        baseDate_input = separate.YMD(baseDate),
                        types = paste(as.character(ratesInfo$type), collapse = ""),
                        rates = as.numeric(as.character(ratesInfo$rate)),
                        expiries = as.character(ratesInfo$expiry),
                        
                        mmDCC = x$mmDCC,
                        fixedSwapFreq = x$fixedFreq,
                        floatSwapFreq = x$floatFreq,
                        fixedSwapDCC = x$fixedDCC,
                        floatSwapDCC = x$floatDCC ,
                        badDayConvZC = x$badDayConvention,
                        holidays = "NONE",
                        
                        todayDate_input = separate.YMD(as.Date(x[i, date.var])),
                        valueDate_input = separate.YMD(cdsDates$valueDate),
                        benchmarkDate_input = separate.YMD(cdsDates$startDate),
                        startDate_input = separate.YMD(cdsDates$startDate),
                        endDate_input = separate.YMD(cdsDates$endDate),
                        stepinDate_input = separate.YMD(cdsDates$stepinDate),
                        
                        dccCDS = "ACT/360",
                        ivlCDS = "1Q",
                        stubCDS = "F",
                        badDayConvCDS = "F",
                        calendar = "NONE",
                        
                        parSpread = x[i, spread.var],
                        couponRate = x[i, coupon.var],
                        recoveryRate = x[i, recovery.var],
                        isPriceClean_input = isPriceClean,
                        payAccruedOnDefault_input = TRUE,
                        notional = notional,
                        PACKAGE = "CDS")
  } 
  return(results)
}