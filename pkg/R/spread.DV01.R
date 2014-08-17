#' Calculate Spread Change
#' 
#' \code{spread.DV01} calculates the spread DV01 or change in upfront 
#' value when the spread rises by 1 basis point
#' 
#' @inheritParams CS10
#' 
#' @return a vector containing the change in upfront when there is a 1
#' basis point increase in spread, for each corresponding CDS contract.
#' @examples 
#' x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' maturity = c(NA, NA),
#' tenor = c(5, 5),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recoveryRate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' 
spread.DV01 <- function(x,
                        TDate.var = "dates",
                        currency.var = "currency",
                        maturity.var = "maturity",
                        tenor.var = "tenor",
                        parSpread.var = "spread",
                        coupon.var = "coupon",
                        recoveryRate.var = "recoveryRate",
                        isPriceClean = FALSE,
                        payAccruedOnDefault = TRUE,
                        notional.var = "notional"
){
  
  ## check if certain variables are contained in x
  
  x <- check.inputs(x)
    
  ## vector containing recRisk01 columns. By default it contains NAs, which
  ## will be replaced by the recRisk01 values calculated by the function
  
  spread.DV01 <- rep(NA, nrow(x))
  
  for(i in 1:nrow(x)){
    
    ## stop if TDate is invalid
    
    stopifnot(check.date(x[[TDate.var]][i]))  
    
    ## Base date is TDate + 2 weekedays. For JPY, the baseDate is TDate + 2 business days.
    
    baseDate <- .adj.next.bus.day(as.Date(x[[TDate.var]][i]) + 2)
    TDate <- x[[TDate.var]][i]
    currency <- x[[currency.var]][i]
    
    #baseDate <- x[[TDate.var]][i] + 2
    
    if(as.POSIXlt(baseDate)$wday == 1){ 
      baseDate <- baseDate + 1
    }
    
    baseDate <- JPY.condition(baseDate = baseDate, TDate = TDate, 
                              currency = currency)
    
    ## if maturity date is not given we use the tenor and vice-versa, to get dates using
    ## get.date function. Results are stored in cdsdates
    
    if(is.null(x[[maturity.var]][i]) | is.na(x[[maturity.var]][i])){
      cdsDates <- get.date(date = as.Date(x[[TDate.var]][i]), 
                           tenor = x[[tenor.var]][i], maturity = NULL)
    }
    else if(is.null(x[[tenor.var]][i])){
      cdsDates <- get.date(date = as.Date(x[[TDate.var]][i]), 
                           tenor = NULL, maturity = as.Date(x[[maturity.var]][i]))
    } ## if both are entered, we arbitrarily use one of them
    
    else if((!is.null(x[[tenor.var]][i])) & !is.null(x[[maturity.var]][i])){
      cdsDates <- get.date(date = as.Date(x[[TDate.var]][i]), 
                           tenor = NULL, maturity = as.Date(x[[maturity.var]][i]))
    }

    
    ## relevant dates are extracted from get.dates and then separated into year,
    ## month and date using separate.YMD (in internals.R). This is the format
    ## required by the C code
    
    valueDate     <- cdsDates$valueDate
    benchmarkDate <- cdsDates$startDate
    startDate     <- cdsDates$startDate
    endDate       <- cdsDates$endDate
    stepinDate    <- cdsDates$stepinDate
        
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x[[TDate.var]][i], currency = x[[currency.var]][i])
        
    ## call the upfront function using the above variables
    
    upfront.orig <- .Call('calcUpfrontTest',
                          baseDate_input = separate.YMD(baseDate),
                          types = paste(as.character(ratesInfo[[1]]$type), collapse = ""),
                          rates = as.numeric(as.character(ratesInfo[[1]]$rate)),
                          expiries = as.character(ratesInfo[[1]]$expiry),
                          
                          mmDCC = as.character(ratesInfo[[2]]$mmDCC),
                          fixedSwapFreq = as.character(ratesInfo[[2]]$fixedFreq),
                          floatSwapFreq = as.character(ratesInfo[[2]]$floatFreq),
                          fixedSwapDCC = as.character(ratesInfo[[2]]$fixedDCC),
                          floatSwapDCC = as.character(ratesInfo[[2]]$floatDCC),
                          badDayConvZC = as.character(ratesInfo[[2]]$badDayConvention),
                          holidays = "None",
                          
                          todayDate_input = separate.YMD(x[[TDate.var]][i]),
                          valueDate_input = separate.YMD(valueDate),
                          benchmarkDate_input = separate.YMD(benchmarkDate),
                          startDate_input = separate.YMD(startDate),
                          endDate_input = separate.YMD(endDate),
                          stepinDate_input = separate.YMD(stepinDate),
                          
                          dccCDS = "ACT/360",
                          ivlCDS = "1Q",
                          stubCDS = "F",
                          badDayConvCDS = "F",
                          calendar = "None",
                          
                          parSpread = x[[parSpread.var]][i],
                          couponRate = x[[coupon.var]][i],
                          recoveryRate = x[[recoveryRate.var]][i],
                          isPriceClean_input = isPriceClean,
                          payAccruedOnDefault_input = payAccruedOnDefault,
                          notional = x[[notional.var]][i],
                          PACKAGE = "CDS")
    
    ## call the upfront function again, this time with recoveryRate + 0.1
    
    upfront.new <- .Call('calcUpfrontTest',
                         baseDate_input = separate.YMD(baseDate),
                         types = paste(as.character(ratesInfo[[1]]$type), collapse = ""),
                         rates = as.numeric(as.character(ratesInfo[[1]]$rate)),
                         expiries = as.character(ratesInfo[[1]]$expiry),
                         
                         mmDCC = as.character(ratesInfo[[2]]$mmDCC),
                         fixedSwapFreq = as.character(ratesInfo[[2]]$fixedFreq),
                         floatSwapFreq = as.character(ratesInfo[[2]]$floatFreq),
                         fixedSwapDCC = as.character(ratesInfo[[2]]$fixedDCC),
                         floatSwapDCC = as.character(ratesInfo[[2]]$floatDCC),
                         badDayConvZC = as.character(ratesInfo[[2]]$badDayConvention),
                         holidays = "None",
                         
                         todayDate_input = separate.YMD(x[[TDate.var]][i]),
                         valueDate_input = separate.YMD(valueDate),
                         benchmarkDate_input = separate.YMD(benchmarkDate),
                         startDate_input = separate.YMD(startDate),
                         endDate_input = separate.YMD(endDate),
                         stepinDate_input = separate.YMD(stepinDate),
                         
                         dccCDS = "ACT/360",
                         ivlCDS = "1Q",
                         stubCDS = "F",
                         badDayConvCDS = "F",
                         calendar = "None",
                         
                         parSpread = x[[parSpread.var]][i] + 1,
                         couponRate = x[[coupon.var]][i],
                         recoveryRate = x[[recoveryRate.var]][i],
                         isPriceClean_input = isPriceClean,
                         payAccruedOnDefault_input = payAccruedOnDefault,
                         notional = x[[notional.var]][i],
                         PACKAGE = "CDS")
    
    spread.DV01[i] <- upfront.new - upfront.orig
    
  }
  
  return(spread.DV01)
}
