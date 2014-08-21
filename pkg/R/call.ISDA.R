#' call ISDA c function
#' 
#' \code{call.ISDA} call ISDA function
#' 
#' @param name character function name within which call.ISDA is called
#' @param x dataframe which contains relevant dates and convention info
#' @param ratesInfo dataframe which contains relevant rates data
#' @param i integer which indicates which iteration of the loop we are currently at
#' 
#' @return a numeric value which is the difference between the new upfront and the old one

call.ISDA <- function(name,
                      x = x,
                      ratesInfo = ratesInfo,
                      i = i){
  ## define default
  
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
  
  upfront.orig <- .Call('calcUpfrontTest',
                        baseDate_input = separate.YMD(x$baseDate[i]),
                        types = paste(as.character(ratesInfo$type), collapse = ""),
                        rates = as.numeric(as.character(ratesInfo$rate)),
                        expiries = as.character(ratesInfo$expiry),
                        
                        mmDCC = as.character(x$mmDCC[i]),
                        fixedSwapFreq = as.character(x$fixedFreq[i]),
                        floatSwapFreq = as.character(x$floatFreq[i]),
                        fixedSwapDCC = as.character(x$fixedDCC[i]),
                        floatSwapDCC = as.character(x$floatDCC[i]),
                        badDayConvZC = as.character(x$badDayConvention[i]),
                        holidays = "None",
                        
                        todayDate_input = separate.YMD(x$date[i]),
                        valueDate_input = separate.YMD(x$valueDate[i]),
                        benchmarkDate_input = separate.YMD(x$startDate[i]),
                        startDate_input = separate.YMD(x$startDate[i]),
                        endDate_input = separate.YMD(x$endDate[i]),
                        stepinDate_input = separate.YMD(x$stepinDate[i]),
                        
                        dccCDS = "ACT/360",
                        ivlCDS = "1Q",
                        stubCDS = "F",
                        badDayConvCDS = "F",
                        calendar = "None",
                        
                        parSpread = x$spread[i],
                        couponRate = x$coupon[i],
                        recoveryRate = x$recovery.rate[i],
                        isPriceClean_input = FALSE,
                        payAccruedOnDefault_input = TRUE,
                        notional = x$notional[i],
                        PACKAGE = "CDS")
  

  
  upfront.new <- .Call('calcUpfrontTest',
                       baseDate_input = separate.YMD(x$baseDate[i]),
                       types = paste(as.character(ratesInfo$type), collapse = ""),
                       rates = as.numeric(as.character(ratesInfo$rate)) + IR.DV01 * 1/1e4,
                       expiries = as.character(ratesInfo$expiry),
                       
                       mmDCC = as.character(x$mmDCC[i]),
                       fixedSwapFreq = as.character(x$fixedFreq[i]),
                       floatSwapFreq = as.character(x$floatFreq[i]),
                       fixedSwapDCC = as.character(x$fixedDCC[i]),
                       floatSwapDCC = as.character(x$floatDCC[i]),
                       badDayConvZC = as.character(x$badDayConvention[i]),
                       holidays = "None",
                       
                       todayDate_input = separate.YMD(x$date[i]),
                       valueDate_input = separate.YMD(x$valueDate[i]),
                       benchmarkDate_input = separate.YMD(x$startDate[i]),
                       startDate_input = separate.YMD(x$startDate[i]),
                       endDate_input = separate.YMD(x$endDate[i]),
                       stepinDate_input = separate.YMD(x$stepinDate[i]),
                       
                       dccCDS = "ACT/360",
                       ivlCDS = "1Q",
                       stubCDS = "F",
                       badDayConvCDS = "F",
                       calendar = "None",
                       
                       parSpread = x$spread[i] * (1 + CS10 * 0.1) + spread.DV01,
                       couponRate = x$coupon[i],
                       recoveryRate = x$recovery.rate[i] + 0.01 * rec.risk.01,
                       isPriceClean_input = FALSE,
                       payAccruedOnDefault_input = TRUE,
                       notional = x$notional[i],
                       PACKAGE = "CDS")
  
  return(upfront.new - upfront.orig)
}