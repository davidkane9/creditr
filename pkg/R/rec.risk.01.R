#' Calculate RR change
#' 
#' \code{rec.risk.01} calculate the amount of change in upfront when there is a 1%
#' increase in recovery rate for a data frame of CDS contracts.
#'
#' @inheritParams CS10
#' 
#' @return a vector containing the change in upfront when there is a 1
#' percent increase in recovery rate, for each corresponding CDS contract.
#' @examples 
#' x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' tenor = c(5, 5),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recovery.rate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' result <- rec.risk.01(x)

rec.risk.01 <- function(x,
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
  
  ## change the column names anyway
  
  colnames(x)[which(colnames(x) == date.var)] <- "date"
  colnames(x)[which(colnames(x) == currency.var)] <- "currency"
  colnames(x)[which(colnames(x) == maturity.var)] <- "maturity"
  colnames(x)[which(colnames(x) == tenor.var)] <- "tenor"
  colnames(x)[which(colnames(x) == spread.var)] <- "spread"
  colnames(x)[which(colnames(x) == coupon.var)] <- "coupon"
  colnames(x)[which(colnames(x) == RR.var)] <- "recovery.rate"
  colnames(x)[which(colnames(x) == notional.var)] <- "notional"
  
  rec.risk.01 <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
  
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x$date[i], currency = x$currency[i])
    
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
    
    ## call the upfront function again, this time with rates + 1/1e4
    
    upfront.new <- .Call('calcUpfrontTest',
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
                         recoveryRate = x$recovery.rate[i] + 0.01,
                         isPriceClean_input = FALSE,
                         payAccruedOnDefault_input = TRUE,
                         notional = x$notional[i],
                         PACKAGE = "CDS")
    
    rec.risk.01[i] <- upfront.new - upfront.orig
  }
  
  return(rec.risk.01)
  
}