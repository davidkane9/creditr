#' \code{CS10} Calculates the change in upfront value when the parSpread rises by 10%, 
#' also known as the CS10 of a contract.
#' @param x is the data frame containing all the relevant columns.
#' @param TDate.var name of column in x containing dates when the trade 
#' is executed, denoted as T. Default is \code{Sys.Date}  + 2 weekdays.
#' @param currency.var name of column in x containing currencies. 
#' @param maturity.var name of column in x containing maturity dates.
#' @param tenor.var name of column in x containing tenors.
#' @param parSpread.var name of column in x containing  par spreads in bps.
#' @param coupon.var name of column in x containing coupon rates in bps. 
#' It specifies the payment amount from the protection buyer to the seller 
#' on a regular basis.
#' @param recoveryRate.var name of column in x containing recovery 
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
#' @return a vector containing the change in upfront when parSpread increase by
#' 10%, for each corresponding CDS contract.
#' @example 
#' x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' maturity = c(NA, NA),
#' tenor = c("5Y", "5Y"),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recoveryRate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' result <- CS10(x)

CS10 <- function(x,
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
  
  x <- check.dataframe(x)
  
  ## vector containing recRisk01 columns. By default it contains NAs, which
  ## will be replaced by the recRisk01 values calculated by the function
  
  CS10 <- rep(NA, nrow(x))
  
  for(i in 1:nrow(x)){
    
    ## stop if TDate is invalid
    
    if(check.date(x[[TDate.var]][i]) == FALSE){
      warning("The dates provided are future dates")
    }  
    
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
    ## month and date using .separate.YMD (in internals.R). This is the format
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
                          baseDate_input = .separate.YMD(baseDate),
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
                          
                          todayDate_input = .separate.YMD(x[[TDate.var]][i]),
                          valueDate_input = .separate.YMD(valueDate),
                          benchmarkDate_input = .separate.YMD(benchmarkDate),
                          startDate_input = .separate.YMD(startDate),
                          endDate_input = .separate.YMD(endDate),
                          stepinDate_input = .separate.YMD(stepinDate),
                          
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
                         baseDate_input = .separate.YMD(baseDate),
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
                         
                         todayDate_input = .separate.YMD(x[[TDate.var]][i]),
                         valueDate_input = .separate.YMD(valueDate),
                         benchmarkDate_input = .separate.YMD(benchmarkDate),
                         startDate_input = .separate.YMD(startDate),
                         endDate_input = .separate.YMD(endDate),
                         stepinDate_input = .separate.YMD(stepinDate),
                         
                         dccCDS = "ACT/360",
                         ivlCDS = "1Q",
                         stubCDS = "F",
                         badDayConvCDS = "F",
                         calendar = "None",
                         
                         parSpread = x[[parSpread.var]][i] * 1.1,
                         couponRate = x[[coupon.var]][i],
                         recoveryRate = x[[recoveryRate.var]][i],
                         isPriceClean_input = isPriceClean,
                         payAccruedOnDefault_input = payAccruedOnDefault,
                         notional = x[[notional.var]][i],
                         PACKAGE = "CDS")
    
    CS10[i] <- upfront.new - upfront.orig
    
  }
  
  return(CS10)
  
}