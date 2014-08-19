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
#' x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' tenor = c(5, 5),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recovery.rate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' spread.DV01(x)

spread.DV01 <- function(x,
                    date.var = "date",
                    currency.var = "currency",
                    maturity.var = "maturity",
                    tenor.var = "tenor",
                    spread.var = "spread",
                    coupon.var = "coupon",
                    RR.var = "recovery.rate",
                    notional.var = "notional"
){
  
  ## vector containing recRisk01 columns. By default it contains NAs, which
  ## will be replaced by the recRisk01 values calculated by the function
  
  ## check if certain variables are contained in x
  
  x <- check.inputs(x, date.var = date.var, currency.var = currency.var,
                    maturity.var = maturity.var, tenor.var = tenor.var,
                    spread.var = spread.var, coupon.var = coupon.var,
                    notional.var = notional.var)
  
  IR.DV01 <- rep(NA, nrow(x))
  
  baseDate.vec <- lapply(adj.next.bus.day(x[[date.var]] + 2), function(y){
    if(as.POSIXlt(y)$wday == 1){ 
      y <- y + 1
    }
    y})
  
  baseDate.vec <- JPY.condition(baseDate = baseDate.vec, date = x[[date.var]], 
                                currency = x[[currency.var]])
  
  cdsDates <- add.dates(x)
  
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x[[date.var]][i], currency = x[[currency.var]][i])
    
    ## call the upfront function using the above variables
    
    upfront.orig <- .Call('calcUpfrontTest',
                          baseDate_input = separate.YMD(baseDate.vec[[i]]),
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
                          
                          todayDate_input = separate.YMD(x[[date.var]][i]),
                          valueDate_input = separate.YMD(cdsDates$valueDate[i]),
                          benchmarkDate_input = separate.YMD(cdsDates$startDate[i]),
                          startDate_input = separate.YMD(cdsDates$startDate[i]),
                          endDate_input = separate.YMD(cdsDates$endDate[i]),
                          stepinDate_input = separate.YMD(cdsDates$stepinDate[i]),
                          
                          dccCDS = "ACT/360",
                          ivlCDS = "1Q",
                          stubCDS = "F",
                          badDayConvCDS = "F",
                          calendar = "None",
                          
                          parSpread = x[[spread.var]][i],
                          couponRate = x[[coupon.var]][i],
                          recoveryRate = x[[RR.var]][i],
                          isPriceClean_input = FALSE,
                          payAccruedOnDefault_input = TRUE,
                          notional = x[[notional.var]][i],
                          PACKAGE = "CDS")
    
    ## call the upfront function again, this time with rates + 1/1e4
    
    upfront.new <- .Call('calcUpfrontTest',
                         baseDate_input = separate.YMD(baseDate.vec[[i]]),
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
                         
                         todayDate_input = separate.YMD(x[[date.var]][i]),
                         valueDate_input = separate.YMD(cdsDates$valueDate[i]),
                         benchmarkDate_input = separate.YMD(cdsDates$startDate[i]),
                         startDate_input = separate.YMD(cdsDates$startDate[i]),
                         endDate_input = separate.YMD(cdsDates$endDate[i]),
                         stepinDate_input = separate.YMD(cdsDates$stepinDate[i]),
                         
                         dccCDS = "ACT/360",
                         ivlCDS = "1Q",
                         stubCDS = "F",
                         badDayConvCDS = "F",
                         calendar = "None",
                         
                         parSpread = x[[spread.var]][i] + 1,
                         couponRate = x[[coupon.var]][i],
                         recoveryRate = x[[RR.var]][i],
                         isPriceClean_input = FALSE,
                         payAccruedOnDefault_input = TRUE,
                         notional = x[[notional.var]][i],
                         PACKAGE = "CDS")
    
    IR.DV01[i] <- upfront.new - upfront.orig
  }
  
  return(IR.DV01)
  
}