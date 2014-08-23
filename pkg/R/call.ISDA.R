#' call ISDA c function
#' 
#' \code{call.ISDA} call ISDA function
#' 
#' @param name character function name within which call.ISDA is called
#' @param x dataframe which contains relevant dates and convention info
#' @param ratesInfo dataframe which contains relevant rates data
#' @return a numeric value which is the difference between the new upfront and the old one

call.ISDA <- function(x, name, ratesInfo){
  
  ## define CS10, IR.DV01, rec.risk.01 and spread.DV01 and set their default
  ## to zero. If the name matches any of the four functions, then the corres-
  ## ponding value for that function will be given value one.
  
  CS10        <- 0
  IR.DV01     <- 0
  rec.risk.01 <- 0
  spread.DV01 <- 0
  
  if(name == "CS10"){
    CS10 <- 1
  } else if(name == "IR.DV01"){
    IR.DV01 <- 1
  } else if(name == "rec.risk.01"){
    rec.risk.01 <- 1
  } else if(name == "spread.DV01"){
    spread.DV01 <- 1
  } else{
    warning("No change provided")
  }
  
  ## original upfront
  
  upfront.orig <- .Call('calcUpfrontTest',
                        baseDate_input = separate.YMD(x$baseDate),
                        types = paste(as.character(ratesInfo$type), collapse = ""),
                        rates = as.numeric(as.character(ratesInfo$rate)),
                        expiries = as.character(ratesInfo$expiry),
                        
                        mmDCC = as.character(x$mmDCC),
                        fixedSwapFreq = as.character(x$fixedFreq),
                        floatSwapFreq = as.character(x$floatFreq),
                        fixedSwapDCC = as.character(x$fixedDCC),
                        floatSwapDCC = as.character(x$floatDCC),
                        badDayConvZC = as.character(x$badDayConvention),
                        holidays = "None",
                        
                        todayDate_input = separate.YMD(x$date),
                        valueDate_input = separate.YMD(x$valueDate),
                        benchmarkDate_input = separate.YMD(x$startDate),
                        startDate_input = separate.YMD(x$startDate),
                        endDate_input = separate.YMD(x$endDate),
                        stepinDate_input = separate.YMD(x$stepinDate),
                        
                        dccCDS = "ACT/360",
                        ivlCDS = "1Q",
                        stubCDS = "F",
                        badDayConvCDS = "F",
                        calendar = "None",
                        
                        parSpread = x$spread,
                        couponRate = x$coupon,
                        recoveryRate = x$recovery.rate,
                        isPriceClean_input = FALSE,
                        payAccruedOnDefault_input = TRUE,
                        notional = x$notional,
                        PACKAGE = "CDS")
  
  ## new upfront
  
  upfront.new <- .Call('calcUpfrontTest',
                       baseDate_input = separate.YMD(x$baseDate),
                       types = paste(as.character(ratesInfo$type), collapse = ""),
                       rates = as.numeric(as.character(ratesInfo$rate)) + IR.DV01 * 1/1e4,
                       expiries = as.character(ratesInfo$expiry),
                       
                       mmDCC = as.character(x$mmDCC),
                       fixedSwapFreq = as.character(x$fixedFreq),
                       floatSwapFreq = as.character(x$floatFreq),
                       fixedSwapDCC = as.character(x$fixedDCC),
                       floatSwapDCC = as.character(x$floatDCC),
                       badDayConvZC = as.character(x$badDayConvention),
                       holidays = "None",
                       
                       todayDate_input = separate.YMD(x$date),
                       valueDate_input = separate.YMD(x$valueDate),
                       benchmarkDate_input = separate.YMD(x$startDate),
                       startDate_input = separate.YMD(x$startDate),
                       endDate_input = separate.YMD(x$endDate),
                       stepinDate_input = separate.YMD(x$stepinDate),
                       
                       dccCDS = "ACT/360",
                       ivlCDS = "1Q",
                       stubCDS = "F",
                       badDayConvCDS = "F",
                       calendar = "None",
                       
                       parSpread = x$spread * (1 + CS10 * 0.1) + spread.DV01,
                       couponRate = x$coupon,
                       recoveryRate = x$recovery.rate + 0.01 * rec.risk.01,
                       isPriceClean_input = FALSE,
                       payAccruedOnDefault_input = TRUE,
                       notional = x$notional,
                       PACKAGE = "CDS")
  
  return(upfront.new - upfront.orig)
}