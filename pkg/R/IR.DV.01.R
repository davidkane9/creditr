#' \code{IR.DV.01}  Calculate the IR DV01 from conventional spread
#'
#' @param object is the \code{CDS} class object.
#' @param TDate is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}.
#' @param baseDate is the start date for the IR curve. Default is TDate + 2 weekdays. 
#' @param currency in which CDS is denominated. 
#' @param types is a string indicating the names of the instruments
#' used for the yield curve. 'M' means money market rate; 'S' is swap
#' rate.
#' @param rates is an array of numeric values indicating the rate of
#' each instrument.
#' @param expiries is an array of characters indicating the maturity
#' of each instrument.
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
#' @param valueDate is the date for which the present value of the CDS
#' is calculated. aka cash-settle date. The default is T + 3.
#' @param benchmarkDate Accrual begin date.
#' @param startDate is when the CDS nomially starts in terms of
#' premium payments, i.e. the number of days in the first period (and
#' thus the amount of the first premium payment) is counted from this
#' date. aka accrual begin date.
#' @param endDate aka maturity date. This is when the contract expires
#' and protection ends. Any default after this date does not trigger a
#' payment.
#' @param stepinDate default is T + 1.
#' @param maturity date of the CDS contract.
#' @param tenor of the CDS contract.
#' @param dccCDS day count convention of the CDS. Default is ACT/360.
#' @param freqCDS date interval of the CDS contract.
#' @param stubCDS is a character indicating the presence of a stub.
#' @param badDayConvCDS refers to the bay day conversion for the CDS
#' coupon payments. Default is "F", following.
#' @param calendar refers to any calendar adjustment for the CDS.
#' @param parSpread CDS par spread in bps.
#' @param coupon quoted in bps. It specifies the payment amount from
#' the protection buyer to the seller on a regular basis.
#' @param recoveryRate in decimal. Default is 0.4.
#' @param isPriceClean refers to the type of upfront calculated. It is
#' boolean. When \code{TRUE}, calculate principal only. When
#' \code{FALSE}, calculate principal + accrual.
#' @param payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' @param notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' 
#' @return a numeric indicating the change in upfront when every point
#' on the IR curve goes up by 1 bp.
#' 

IR.DV.01 <- function(object = NULL,
                   TDate,
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
                   freqCDS = "1Q",
                   stubCDS = "F",
                   badDayConvCDS = "F",
                   calendar = "None",
                   
                   parSpread,
                   coupon=100,
                   recoveryRate = 0.4,
                   isPriceClean = FALSE,
                   payAccruedOnDefault = TRUE,                       
                   notional = 1e7
                   ){
    
    ## stop if TDate is invalid
  
    stopifnot(check.date(TDate))  
  
    ## for JPY, the baseDate is TDate + 2 bus days, whereas for the rest it is TDate + 2 weekdays
    
    if(currency=="JPY"){        
      baseDate <- .adj.next.bus.day(as.Date(TDate) + 2)
      JPY.holidays <- suppressWarnings(as.Date(readLines(system.file("data/TYO.DAT.txt", package = "CDS")), "%Y%m%d"))
      
      ## if base date is one of the Japanese holidays we add another business day to it
      
      if(baseDate %in% JPY.holidays){
        baseDate <- .adj.next.bus.day(as.Date(TDate) + 1)
      }
    }
    ratesDate <- as.Date(TDate)
    
    ## if maturity date is not provided, we use tenor to obtain dates through get.date,
    ## and vice versa.
    
    if(is.null(maturity)){
      cdsDates <- get.date(date = as.Date(TDate), tenor = tenor, maturity = NULL)
    }
    else if(is.null(tenor)){
      cdsDates <- get.date(date = as.Date(TDate), tenor = NULL, maturity = as.Date(maturity))
    }
    
    ## if these dates are not entered, they are extracted using get.date
    
    if (is.null(valueDate)) valueDate         <- cdsDates$valueDate
    if (is.null(benchmarkDate)) benchmarkDate <- cdsDates$startDate
    if (is.null(startDate)) startDate         <- cdsDates$startDate
    if (is.null(endDate)) endDate             <- cdsDates$endDate
    if (is.null(stepinDate)) stepinDate       <- cdsDates$stepinDate

    ## separate an input date into year, month, and day
    
    baseDate      <- .separate.YMD(baseDate)
    today         <- .separate.YMD(TDate)
    valueDate     <- .separate.YMD(valueDate)
    benchmarkDate <- .separate.YMD(benchmarkDate)
    startDate     <- .separate.YMD(startDate)
    endDate       <- .separate.YMD(endDate)
    stepinDate    <- .separate.YMD(stepinDate)

    ## stop if number of rates != number of expiries != length of types
    
    stopifnot(all.equal(length(rates), length(expiries), nchar(types)))    
    
    ## if any of these three are null, we extract them using get.rates
    
    if ((is.null(types) | is.null(rates) | is.null(expiries))){
        
        ## interest rates contained in list 1 of ratesInfo
        
        ratesInfo <- get.rates(date = ratesDate, currency = currency)
        types     <- paste(as.character(ratesInfo[[1]]$type), collapse = "")
        rates     <- as.numeric(as.character(ratesInfo[[1]]$rate))
        expiries  <- as.character(ratesInfo[[1]]$expiry)
        mmDCC     <- as.character(ratesInfo[[2]]$mmDCC)
        
        ## date convention standards etc. contained in list 2 of ratesInfo
        
        fixedSwapFreq <- as.character(ratesInfo[[2]]$fixedFreq)
        floatSwapFreq <- as.character(ratesInfo[[2]]$floatFreq)
        fixedSwapDCC  <- as.character(ratesInfo[[2]]$fixedDCC)
        floatSwapDCC  <- as.character(ratesInfo[[2]]$floatDCC)
        badDayConvZC  <- as.character(ratesInfo[[2]]$badDayConvention)
        holidays      <- as.character(ratesInfo[[2]]$swapCalendars)
    }

    ## calculate upfront using C code
    
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

    ## calculate upfront using C code
    
    upfront.new <- .Call('calcUpfrontTest',
                         baseDate,
                         types,
                         rates + 1/1e4,
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
    
    ## difference in the two upfront payments is the change in upfront with a 1bp
    ## change in IR curve
    
    return (upfront.new - upfront.orig)
    
}



#' The IRDV01 method for CDS class. Calculate the IRDV01 from
#' conventional spread
#' 
#' @name IR.DV.01-method
#' @aliases IR.DV.01,CDS-method
#' @docType methods
#' @rdname IR.DV.01-methods
#' @param object the input CDS class object
#' @export

setMethod("IR.DV.01",
          signature(object = "CDS"),
          function(object){
              baseDate      <- .separate.YMD(object@baseDate)
              today         <- .separate.YMD(object@TDate)
              valueDate     <- .separate.YMD(object@valueDate)
              benchmarkDate <- .separate.YMD(object@benchmarkDate)
              startDate     <- .separate.YMD(object@startDate)
              endDate       <- .separate.YMD(object@endDate)
              stepinDate    <- .separate.YMD(object@stepinDate)

              upfront.new <- .Call('calcUpfrontTest',
                                   baseDate,
                                   object@types,
                                   object@rates + 1/1e4,
                                   object@expiries,
                                   
                                   object@mmDCC,
                                   object@fixedSwapFreq,
                                   object@floatSwapFreq,
                                   object@fixedSwapDCC,
                                   object@floatSwapDCC,
                                   object@badDayConvZC,
                                   object@holidays,
                                   
                                   today,
                                   valueDate,
                                   benchmarkDate,
                                   startDate,
                                   endDate,
                                   stepinDate,
                                   
                                   object@dccCDS,
                                   object@freqCDS,
                                   object@stubCDS,
                                   object@badDayConvCDS,
                                   object@calendar,
                                   
                                   object@parSpread,
                                   object@coupon,
                                   object@recoveryRate,
                                   isPriceClean = FALSE,
                                   object@payAccruedOnDefault,
                                   object@notional,
                                   PACKAGE = "CDS")

                 return (upfront.new - object@upfront)
          }
          
          )
