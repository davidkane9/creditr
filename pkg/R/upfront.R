#' Calculate Upfront Payments
#' 
#' \code{upfront} takes a dataframe of variables on CDSs to return a vector of
#' upfront values. Note that all CDS in the data frame must be denominated in 
#' the same currency.
#' 
#' @inheritParams CS10
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
  
  results <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
  
  for(i in 1:nrow(x)){
    
    ratesInfo <- get.rates(date = as.Date(x[i, date.var]), currency = x[i, currency.var])
    
    results[i] <- .Call('calcUpfrontTest',
                        baseDate_input = separate.YMD(x$baseDate[i]),
                        types = paste(as.character(ratesInfo$type), collapse = ""),
                        rates = as.numeric(as.character(ratesInfo$rate)),
                        expiries = as.character(ratesInfo$expiry),
                        
                        mmDCC = x$mmDCC[i],
                        fixedSwapFreq = x$fixedFreq[i],
                        floatSwapFreq = x$floatFreq[i],
                        fixedSwapDCC = x$fixedDCC[i],
                        floatSwapDCC = x$floatDCC[i] ,
                        badDayConvZC = x$badDayConvention[i],
                        holidays = "NONE",
                        
                        todayDate_input = separate.YMD(as.Date(x[i, date.var])),
                        valueDate_input = separate.YMD(x$valueDate[i]),
                        benchmarkDate_input = separate.YMD(x$startDate[i]),
                        startDate_input = separate.YMD(x$startDate[i]),
                        endDate_input = separate.YMD(x$endDate[i]),
                        stepinDate_input = separate.YMD(x$stepinDate[i]),
                        
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