#' Calculate CS10
#' 
#' \code{CS10} Calculates the change in upfront value when the spread rises by 10%, 
#' also known as the CS10 of a contract.
#' 
#' @param x is the data frame containing all the relevant columns.
#' @param date.var name of column in x containing dates when the trade 
#' is executed, denoted as T. Default is \code{Sys.Date}  + 2 weekdays.
#' @param currency.var name of column in x containing currencies. 
#' @param maturity.var name of column in x containing maturity dates.
#' @param tenor.var name of column in x containing tenors.
#' @param spread.var name of column in x containing  par spreads in bps.
#' @param coupon.var name of column in x containing coupon rates in bps. 
#' It specifies the payment amount from the protection buyer to the seller 
#' on a regular basis.
#' @param RR.var name of column in x containing recovery 
#' rates in decimal.
#' @param isPriceClean refers to the type of upfront calculated. It is
#' boolean. When \code{TRUE}, calculate principal only. When
#' \code{FALSE}, calculate principal + accrual.
#' @param payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' @param notional.var name of column in x containing the amount of 
#' the underlying asset on which the payments are based. 
#' Default is 1e7, i.e. 10MM.
#' 
#' @return a vector containing the change in upfront when spread increase by
#' 10%, for each corresponding CDS contract.
#' 
#' @examples 
#' x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' tenor = c(5, 5),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recoveryRate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' result <- CS10(x)

CS10 <- function(x,
                    date.var = "date",
                    currency.var = "currency",
                    maturity.var = "maturity",
                    tenor.var = "tenor",
                    spread.var = "spread",
                    coupon.var = "coupon",
                    RR.var = "recoveryRate",
                    notional.var = "notional",
                    isPriceClean = FALSE,
                    payAccruedOnDefault = TRUE
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
  
  baseDate.vec <- JPY.condition(baseDate = baseDate.vec, TDate = x[[date.var]], 
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
                          
                          spread = x[[spread.var]][i],
                          couponRate = x[[coupon.var]][i],
                          recoveryRate = x[[RR.var]][i],
                          isPriceClean_input = isPriceClean,
                          payAccruedOnDefault_input = payAccruedOnDefault,
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
                         
                         spread = x[[spread.var]][i] * 1.1,
                         couponRate = x[[coupon.var]][i],
                         recoveryRate = x[[RR.var]][i],
                         isPriceClean_input = isPriceClean,
                         payAccruedOnDefault_input = payAccruedOnDefault,
                         notional = x[[notional.var]][i],
                         PACKAGE = "CDS")
    
    IR.DV01[i] <- upfront.new - upfront.orig
  }
  
  return(IR.DV01)
  
}