#' \code{spread} to calculate conventional spread using the upfront or ptsUpfront values
#' 
#' @inheritParams CS10
#' @param ptsUpfront.var character name of ptsUpfront column
#' @param isPriceClean a boolean variable indicating whether the upfront is clean or dirty
#' @param notional numeric variable indicating the notional value of the CDS contract
#' @param payAccruedAtStart whether pay at start date the accrual amount
#' @param upfront.var is the character name of upfront column
#' @param payAccruedOnDefault whether pay in default scenario the accrual amount
#' 
#' @return a numeric indicating the spread.

spread <- function(x, 
                   currency.var = "currency", 
                   date.var = "date",
                   coupon.var = "coupon",
                   tenor.var = "tenor",
                   maturity.var = "maturity",
                   RR.var = "recovery.rate",
                   upfront.var = "upfront",
                   ptsUpfront.var = "ptsUpfront",
                   
                   isPriceClean = FALSE,
                   notional = 1e7,
                   payAccruedAtStart = FALSE,
                   payAccruedOnDefault = TRUE){
  
  if (is.null(x[[upfront.var]]) & is.null(x[[ptsUpfront.var]]))
    stop("Please input upfront or pts upfront")
  
  ## You must provide either a maturity or a tenor, but not both.
  
  stopifnot(!(is.null(x[[maturity.var]]) & is.null(x[[tenor.var]])))
  stopifnot(is.null(x[[maturity.var]]) | is.null(x[[tenor.var]]))
  
  spread <- rep(NA, nrow(x))
  
  if (is.null(x[[ptsUpfront.var]])) {
    x[[ptsUpfront.var]] <- x[[upfront.var]] / notional
  } else {
    payAccruedAtStart <- TRUE
  }
  
  x <- add.conventions(add.dates(x))
  x <- cbind(x, spread)
  
  for(i in 1:nrow(x)){
    
    dccCDS = "ACT/360"
    badDayConvCDS = "F"
    calendar = "None"
    
    if(is.null(x[[coupon.var]][i])){
      coupon <- 100 
    } else{
      coupon <- x[[coupon.var]][i]
    }
    
    if(is.null(x[[RR.var]][i])){
      recovery.rate <- 0.4
    } else{
      recovery.rate <- x[[RR.var]][i]
    }
    
    ratesInfo <- get.rates(date = as.Date(x[[date.var]][i]),
                           currency = as.character(x[[currency.var]][i]))
    
    baseDate <- separate.YMD(JPY.condition(baseDate = x$baseDate[i], date = x[[date.var]][i],
                                           currency = as.character(x[[currency.var]][i])))
    
    x$spread[i] <- .Call('calcCdsoneSpread',
                         baseDate_input = baseDate,
                         types = paste(as.character(ratesInfo$type), collapse = ""),
                         rates = as.numeric(as.character(ratesInfo$rate)),
                         expiries = as.character(ratesInfo$expiry),
                         mmDCC = x$mmDCC[i],
                         
                         fixedSwapFreq = x$fixedFreq[i],
                         floatSwapFreq = x$floatFreq[i],
                         fixedSwapDCC = x$fixedDCC[i],
                         floatSwapDCC = x$floatDCC[i],
                         badDayConvZC = x$badDayConvention[i],
                         holidays = x$swapCalendars[i],
                         
                         todayDate_input = separate.YMD(x[[date.var]][i]),
                         valueDate_input = separate.YMD(x$valueDate[i]),
                         benchmarkDate_input = separate.YMD(x$startDate[i]),
                         startDate_input = separate.YMD(x$startDate[i]),
                         endDate_input = separate.YMD(x$endDate[i]),
                         stepinDate_input = separate.YMD(x$stepinDate[i]),
                         
                         couponRate_input = coupon / 1e4,
                         payAccruedOnDefault_input = payAccruedOnDefault,
                         
                         dccCDS = dccCDS,
                         dateInterval = "Q",
                         stubType = "F",
                         badDayConv_input = badDayConvCDS,
                         calendar_input = calendar,
                         
                         upfrontCharge_input = x[[ptsUpfront.var]][i],
                         recoveryRate_input = recovery.rate,
                         payAccruedAtStart_input = payAccruedAtStart,
                         PACKAGE = "CDS")                       
  }
  return(x$spread)
}
