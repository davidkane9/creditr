#' \code{spread} to calculate conventional spread using the upfront or ptsUpfront values
#' 
#' @inheritParams CDS
#' @param payAccruedAtStart whether pay at start date the accrual amount
#' @param spread in bps
#' @param mmDCC is the day count convention of the instruments.
#' @param fixedSwapFreq is the frequency of the fixed rate of swap
#' being paid.
#' @param floatSwapFreq is the frequency of the floating rate of swap
#' being paid.
#' @param fixedSwapDCC is the day count convention of the fixed leg.
#' @param floatSwapDCC is the day count convention of the floating leg.
#' @param badDayConvZC is a character indicating how non-business days
#' are converted.
#' @param holidays is an input for holiday files to adjust to business
#' days.
#' @param dccCDS day count convention of the CDS. Default is ACT/360.
#' @param freqCDS date interval of the CDS contract.
#' @param stubCDS is a character indicating the presence of a stub.
#' @param badDayConvCDS refers to the bay day conversion for the CDS
#' coupon payments. Default is "F", following.
#' @param calendar refers to any calendar adjustment for the CDS.
#' 
#' @return a numeric indicating the spread.

spread <- function(TDate,
                   baseDate = as.Date(TDate) + 2,
                   currency = "USD",

                   types = NULL,
                   rates = NULL,
                   expiries = NULL,
                   mmDCC = "ACT/360",
                   fixedSwapFreq = "6M",
                   floatSwapFreq = "3M",
                   fixedSwapDCC = "30/360",
                   floatSwapDCC = "ACT/360",
                   badDayConvZC = "M",
                   holidays = "None",
                   
                   valueDate = NULL,
                   benchmarkDate = NULL,
                   startDate = NULL,
                   endDate = NULL,
                   stepinDate = NULL,
                   maturity = NULL,
                   tenor = NULL,
                   
                   dccCDS = "ACT/360",
                   freqCDS = "Q",
                   stubCDS = "F",
                   badDayConvCDS = "F",
                   calendar = "None",
                   
                   upfront = NULL,
                   ptsUpfront = NULL,
                   coupon = 100, 
                   recovery.rate = 0.4,
                   payAccruedAtStart = FALSE,
                   notional = 1e7,
                   payAccruedOnDefault = TRUE){

    if (is.null(upfront) & is.null(ptsUpfront))
        stop("Please input upfront or pts upfront")
    
    ## for JPY, the baseDate is TDate + 2 bus days, whereas for the rest it is TDate + 2 weekdays
    
    baseDate <- JPY.condition(baseDate = baseDate, TDate = TDate, 
                              currency = currency)
        
    ## rates Date is the date for which interest rates will be calculated. get.rates 
    ## function will return the rates of the previous day
    
    ratesDate <- as.Date(TDate)
    
    if (is.null(ptsUpfront)) {
        ptsUpfront <- upfront / notional
    } else {
        payAccruedAtStart <- TRUE
    }
    
    if(is.null(maturity)){
      cdsDates <- add.dates(data.frame(date = as.Date(TDate), tenor = tenor))
    }
    else if(is.null(tenor)){
      cdsDates <- add.dates(data.frame(date = as.Date(TDate), 
                           maturity = as.Date(maturity)))
    }
    
    if (is.null(valueDate)) valueDate         <- cdsDates$valueDate
    if (is.null(benchmarkDate)) benchmarkDate <- cdsDates$startDate
    if (is.null(startDate)) startDate         <- cdsDates$startDate
    if (is.null(endDate)) endDate             <- cdsDates$endDate
    if (is.null(stepinDate)) stepinDate       <- cdsDates$stepinDate

    baseDate      <- separate.YMD(baseDate)
    today         <- separate.YMD(TDate)
    valueDate     <- separate.YMD(valueDate)
    benchmarkDate <- separate.YMD(benchmarkDate)
    startDate     <- separate.YMD(startDate)
    endDate       <- separate.YMD(endDate)
    stepinDate    <- separate.YMD(stepinDate)

    stopifnot(all.equal(length(rates), length(expiries), nchar(types)))    
    if ((is.null(types) | is.null(rates) | is.null(expiries))){
        
        ratesInfo <- get.rates(date = ratesDate, currency = as.character(currency))
        types     <- paste(as.character(ratesInfo[[1]]$type), collapse = "")
        rates     <- as.numeric(as.character(ratesInfo[[1]]$rate))
        expiries  <- as.character(ratesInfo[[1]]$expiry)
        mmDCC     <- as.character(ratesInfo[[2]]$mmDCC)
        
        fixedSwapFreq <- as.character(ratesInfo[[2]]$fixedFreq)
        floatSwapFreq <- as.character(ratesInfo[[2]]$floatFreq)
        fixedSwapDCC  <- as.character(ratesInfo[[2]]$fixedDCC)
        floatSwapDCC  <- as.character(ratesInfo[[2]]$floatDCC)
        badDayConvZC  <- as.character(ratesInfo[[2]]$badDayConvention)
        holidays      <- as.character(ratesInfo[[2]]$swapCalendars)
    }

    
    .Call('calcCdsoneSpread',
          baseDate_input = baseDate,
          types = types,
          rates = rates,
          expiries = expiries,
          mmDCC = mmDCC,
          
          fixedSwapFreq = fixedSwapFreq,
          floatSwapFreq = floatSwapFreq,
          fixedSwapDCC = fixedSwapDCC,
          floatSwapDCC = floatSwapDCC,
          badDayConvZC = badDayConvZC,
          holidays = holidays,

          todayDate_input = today,
          valueDate_input = valueDate,
          benchmarkDate_input = benchmarkDate,
          startDate_input = startDate,
          endDate_input = endDate,
          stepinDate_input = stepinDate,
          
          couponRate_input = coupon / 1e4,
          payAccruedOnDefault_input = payAccruedOnDefault,
          
          dccCDS = dccCDS,
          dateInterval = freqCDS,
          stubType = stubCDS,
          badDayConv_input = badDayConvCDS,
          calendar_input = calendar,

          upfrontCharge_input = ptsUpfront,
          recoveryRate_input = recovery.rate,
          payAccruedAtStart_input = payAccruedAtStart,
          PACKAGE = "CDS")

}
