#' \code{spread.DV.01} calculates the spread DV01 or change in upfront 
#' value when the spread rises by 1 basis point
#' 
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
#' @return a vector containing the change in upfront when there is a 1
#' basis point increase in spread, for each corresponding CDS contract.
#' @example 
#' x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' maturity = c(NA, NA),
#' tenor = c("5Y", "5Y"),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recoveryRate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' 
spread.DV.01 <- function(x,
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
  
  stopifnot(c(TDate.var, currency.var, maturity.var, tenor.var, 
              parSpread.var, coupon.var, recoveryRate.var, notional.var) %in% names(x))
  
  ## check if variables are defined in the correct classes
  
  stopifnot(is.numeric(x[[parSpread.var]]))
  stopifnot(is.numeric(x[[coupon.var]]))
  stopifnot(is.numeric(x[[recoveryRate.var]]))
  stopifnot(is.numeric(x[[notional.var]]))
  #stopifnot(is.character(x[[currency.var]]))
  #stopifnot(is.character(x[[tenor.var]]))
  #stopifnot(inherits(x[[TDate.var]], "Date"))
  
  #if(!is.na(maturity.var)){
  # stopifnot(inherits(x[[maturity.var]], "Date"))
  #}
  
  ## vector containing recRisk01 columns. By default it contains NAs, which
  ## will be replaced by the recRisk01 values calculated by the function
  
  spread.DV.01 <- rep(NA, nrow(x))
  
  for(i in 1:nrow(x)){
    
    ## stop if TDate is invalid
    
    stopifnot(check.date(x[[TDate.var]][i]))  
    
    ## Base date is TDate + 2 weekedays. For JPY, the baseDate is TDate + 2 business days.
    
    baseDate <- .adj.next.bus.day(as.Date(x[[TDate.var]][i]) + 2)
    
    #baseDate <- x[[TDate.var]][i] + 2
    
    if(as.POSIXlt(baseDate)$wday == 1){ 
      baseDate <- baseDate + 1
    }
    
    if(x[[currency.var]][i] == "JPY"){        
      baseDate <- .adj.next.bus.day(as.Date(x[[TDate.var]][i]) + 2)
      data(JPY.holidays, package = "CDS")
      
      ## if base date is one of the Japanese holidays we add another business day to it
      
      if(baseDate %in% JPY.holidays){
        baseDate <- .adj.next.bus.day(as.Date(x[[TDate.var]][i]) + 1)
      }
    }
    
    ## if maturity date is not given we use the tenor and vice-versa, to get dates using
    ## get.date function. Results are stored in cdsdates
    
    if(is.null(x[[maturity.var]][i]) | is.na(x[[maturity.var]][i])){
      cdsDates <- get.date(date = as.Date(x[[TDate.var]][i]), tenor = x[[tenor.var]][i], maturity = NULL)
    }
    else if(is.null(x[[tenor.var]][i])){
      cdsDates <- get.date(date = as.Date(x[[TDate.var]][i]), tenor = NULL, maturity = as.Date(x[[maturity.var]][i]))
    } ## if both are entered, we arbitrarily use one of them
    
    else if((!is.null(x[[tenor.var]][i])) & !is.null(x[[maturity.var]][i])){
      cdsDates <- get.date(date = as.Date(x[[TDate.var]][i]), tenor = NULL, maturity = as.Date(x[[maturity.var]][i]))
    }
    
    
    ## relevant dates are extracted from get.dates and then separated into year,
    ## month and date using .separate.YMD (in internals.R). This is the format
    ## required by the C code
    
    valueDate     <- cdsDates$valueDate
    benchmarkDate <- cdsDates$startDate
    startDate     <- cdsDates$startDate
    endDate       <- cdsDates$endDate
    stepinDate    <- cdsDates$stepinDate
    
    baseDate      <- .separate.YMD(baseDate)
    today         <- .separate.YMD(x[[TDate.var]][i])
    valueDate     <- .separate.YMD(valueDate)
    benchmarkDate <- .separate.YMD(benchmarkDate)
    startDate     <- .separate.YMD(startDate)
    endDate       <- .separate.YMD(endDate)
    stepinDate    <- .separate.YMD(stepinDate)
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x[[TDate.var]][i], currency = x[[currency.var]][i])
    types     <- paste(as.character(ratesInfo[[1]]$type), collapse = "")
    rates     <- as.numeric(as.character(ratesInfo[[1]]$rate))
    expiries  <- as.character(ratesInfo[[1]]$expiry)
    mmDCC     <- as.character(ratesInfo[[2]]$mmDCC)
    
    fixedSwapFreq <- as.character(ratesInfo[[2]]$fixedFreq)
    floatSwapFreq <- as.character(ratesInfo[[2]]$floatFreq)
    fixedSwapDCC  <- as.character(ratesInfo[[2]]$fixedDCC)
    floatSwapDCC  <- as.character(ratesInfo[[2]]$floatDCC)
    badDayConvZC  <- as.character(ratesInfo[[2]]$badDayConvention)
    holidays      <- "None"
    
    recoveryRate <- x[[recoveryRate.var]][i]
    
    ## CDS conventions 
    
    dccCDS        <- "ACT/360"
    freqCDS       <- "1Q"
    stubCDS       <- "F"
    badDayConvCDS <- "F"
    calendar      <- "None"
    
    ## spread, coupon rate and notional
    
    parSpread <- x[[parSpread.var]][i]
    coupon    <- x[[coupon.var]][i]
    notional  <- x[[notional.var]][i]
    
    ## call the upfront function using the above variables
    
    upfront.orig <- .Call('calcUpfrontTest',
                          baseDate,
                          types,
                          rates,
                          expiries,
                          
                          mmDCC,
                          fixedSwapFreq,
                          floatSwapFreq,
                          fixedSwapDCC,
                          floatSwapDCC,
                          badDayConvZC,
                          holidays,
                          
                          today,
                          valueDate,
                          benchmarkDate,
                          startDate,
                          endDate,
                          stepinDate,
                          
                          dccCDS,
                          freqCDS,
                          stubCDS,
                          badDayConvCDS,
                          calendar,
                          
                          parSpread,
                          coupon,
                          recoveryRate,
                          isPriceClean,
                          payAccruedOnDefault,
                          notional,
                          PACKAGE = "CDS")
    
    ## call the upfront function again, this time with recoveryRate + 0.1
    
    upfront.new <- .Call('calcUpfrontTest',
                         baseDate,
                         types,
                         rates,
                         expiries,
                         
                         mmDCC,
                         fixedSwapFreq,
                         floatSwapFreq,
                         fixedSwapDCC,
                         floatSwapDCC,
                         badDayConvZC,
                         holidays,
                         
                         today,
                         valueDate,
                         benchmarkDate,
                         startDate,
                         endDate,
                         stepinDate,
                         
                         dccCDS,
                         freqCDS,
                         stubCDS,
                         badDayConvCDS,
                         calendar,
                         
                         parSpread + 1,
                         coupon,
                         recoveryRate,
                         isPriceClean,
                         payAccruedOnDefault,
                         notional,
                         PACKAGE = "CDS")
    
    spread.DV.01[i] <- upfront.new - upfront.orig
    
  }
  
  return(spread.DV.01)
}