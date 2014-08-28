#' \code{upfront.to.spread} to calculate conventional spread using the upfront 
#' or ptsUpfront values
#' 
#' @inheritParams CS10
#' @param points.var character name of points Upfront column
#' @param isPriceClean a boolean variable indicating whether the upfront is clean or dirty
#' @param notional numeric variable indicating the notional value of the CDS contract
#' @param payAccruedAtStart whether pay at start date the accrual amount
#' @param upfront.var is the character name of upfront column
#' @param payAccruedOnDefault whether pay in default scenario the accrual amount
#' 
#' @return a numeric indicating the spread.

upfront.to.spread <- function(x, 
                   currency.var = "currency", 
                   date.var = "date",
                   coupon.var = "coupon",
                   tenor.var = "tenor",
                   maturity.var = "maturity",
                   RR.var = "recovery.rate",
                   upfront.var = "upfront",
                   points.var = "ptsUpfront",
                   
                   isPriceClean = FALSE,
                   notional = 1e7,
                   payAccruedAtStart = FALSE,
                   payAccruedOnDefault = TRUE){
  
  if (is.null(x[[upfront.var]]) & is.null(x[[points.var]]))
    stop("Please input upfront or pts upfront")
  
  ## You must provide either a maturity or a tenor, but not both.
  
  stopifnot(!(is.null(x[[maturity.var]]) & is.null(x[[tenor.var]])))
  stopifnot(is.null(x[[maturity.var]]) | is.null(x[[tenor.var]]))
  
  spread <- rep(NA, nrow(x))
  
  if (is.null(x[[points.var]])) {
    x[[points.var]] <- x[[upfront.var]] / notional
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
    
    rates.info <- get.rates(date = as.Date(x[[date.var]][i]),
                           currency = as.character(x[[currency.var]][i]))
    
    baseDate <- x$baseDate[i]
    
    x$spread[i] <- .Call('calcCdsoneSpread',
                         baseDate_input = separate.YMD(baseDate),
                         types = paste(as.character(rates.info$type), collapse = ""),
                         rates = as.numeric(as.character(rates.info$rate)),
                         expiries = as.character(rates.info$expiry),
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
                         
                         upfrontCharge_input = x[[points.var]][i],
                         recoveryRate_input = recovery.rate,
                         payAccruedAtStart_input = payAccruedAtStart,
                         PACKAGE = "CDS")                       
  }
  return(x$spread)
}
