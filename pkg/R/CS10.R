#' Calculate CS10
#' 
#' \code{CS10} calculates the change in upfront value when the spread rises by 
#' 10%, also known as the CS10 of a contract.
#' 
#' @param x data frame, contains all the relevant columns.
#' @param date.var character, column in x containing date variable.
#' @param currency.var character, column in x containing currency.
#' @param maturity.var character, column in x containing maturity date.
#' @param tenor.var character, column in x containing tenors.
#' @param spread.var character, column in x containing spread in basis points.
#' @param coupon.var character, column in x containing coupon rates in basis 
#'   points. It specifies the payment amount from the protection buyer to the 
#'   seller on an annual basis.
#' @param RR.var character, column in x containing recovery rates. ISDA model 
#'   standard recovery rate asscumption is 0.4.
#' @param notional.var character, column in x containing the amount of the 
#'   underlying asset on which the payments are based.
#'   
#' @return a vector containing the change in upfront in units of currency.var
#'   when spread increase by 10%, for each corresponding CDS contract.
#'   
#' @examples 
#' x <- data.frame(date = as.Date(c("2014-04-22", "2014-04-22")),
#'                 currency = c("USD", "EUR"),
#'                 tenor = c(5, 5),
#'                 spread = c(120, 110),
#'                 coupon = c(100, 100),
#'                 recovery.rate = c(0.4, 0.4),
#'                 notional = c(1e7, 1e7))
#' result <- CS10(x)

CS10 <- function(x,
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
  
  CS10 <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
 
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x[[date.var]][i], currency = x[[currency.var]][i])
    
    ## call the upfront function using the above variables
    
    upfront.orig <- .Call('calcUpfrontTest',
                          baseDate_input = separate.YMD(x$baseDate[i]),
                          types = paste(as.character(ratesInfo[[1]]$type), collapse = ""),
                          rates = as.numeric(as.character(ratesInfo[[1]]$rate)),
                          expiries = as.character(ratesInfo[[1]]$expiry),
                          
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
                         types = paste(as.character(ratesInfo[[1]]$type), collapse = ""),
                         rates = as.numeric(as.character(ratesInfo[[1]]$rate)),
                         expiries = as.character(ratesInfo[[1]]$expiry),
                         
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
                         
                         parSpread = x[[spread.var]][i] * 1.1,
                         couponRate = x[[coupon.var]][i],
                         recoveryRate = x[[RR.var]][i],
                         isPriceClean_input = FALSE,
                         payAccruedOnDefault_input = TRUE,
                         notional = x[[notional.var]][i],
                         PACKAGE = "CDS")
    
    CS10[i] <- upfront.new - upfront.orig
  }
  
  return(CS10)
  
}