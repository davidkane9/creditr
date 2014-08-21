#' Calculate IR.DV01
#' 
#' \code{IR.DV01} calculate the amount of change in upfront when there is a 1/1e4
#' increase in interest rate for a data frame of CDS contracts.
#'
#' @inheritParams CS10
#' 
#' @return a vector containing the change in upfront when there is a 1/1e4
#' increase in interest rate, for each corresponding CDS contract.
#' 
#' @examples 
#' x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' tenor = c(5, 5),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recovery.rate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' result <- IR.DV01(x)

IR.DV01 <- function(x,
                 date.var     = "date",
                 currency.var = "currency",
                 maturity.var = "maturity",
                 tenor.var    = "tenor",
                 spread.var   = "spread",
                 coupon.var   = "coupon",
                 RR.var       = "recovery.rate",
                 notional.var = "notional"){
  
  ## check if certain variables are contained in x
  
  x <- check.inputs(x, date.var = date.var, currency.var = currency.var,
                    maturity.var = maturity.var, tenor.var = tenor.var,
                    spread.var = spread.var, coupon.var = coupon.var,
                    notional.var = notional.var, RR.var = RR.var)
  
  IR.DV01 <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
  
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x[[date.var]][i], currency = x[[currency.var]][i])
    
    ## call the upfront function using the above variables
    
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
                          
                          todayDate_input = separate.YMD(x[[date.var]][i]),
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
                          
                          parSpread = x[[spread.var]][i],
                          couponRate = x[[coupon.var]][i],
                          recoveryRate = x[[RR.var]][i],
                          isPriceClean_input = FALSE,
                          payAccruedOnDefault_input = TRUE,
                          notional = x[[notional.var]][i],
                          PACKAGE = "CDS")
    
    ## call the upfront function again, this time with rates + 1/1e4
    
    upfront.new <- .Call('calcUpfrontTest',
                         baseDate_input = separate.YMD(x$baseDate[i]),
                         types = paste(as.character(ratesInfo$type), collapse = ""),
                         rates = as.numeric(as.character(ratesInfo$rate)) + 1/1e4,
                         expiries = as.character(ratesInfo$expiry),
                         
                         mmDCC = as.character(x$mmDCC[i]),
                         fixedSwapFreq = as.character(x$fixedFreq[i]),
                         floatSwapFreq = as.character(x$floatFreq[i]),
                         fixedSwapDCC = as.character(x$fixedDCC[i]),
                         floatSwapDCC = as.character(x$floatDCC[i]),
                         badDayConvZC = as.character(x$badDayConvention[i]),
                         holidays = "None",
                         
                         todayDate_input = separate.YMD(x[[date.var]][i]),
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
                         
                         parSpread = x[[spread.var]][i],
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