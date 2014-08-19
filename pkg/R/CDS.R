#' Build a \code{CDS} class object given the input about a CDS
#' contract.
#' 
#' @name CDS
#' 
#' @param contract is the contract type, default SNAC
#' @param entityName is the name of the reference entity. Optional.
#' @param RED alphanumeric code assigned to the reference entity. Optional.
#' @param TDate is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}. The date format should be in "YYYY-MM-DD".
#' @param baseDate is the start date for the IR curve. Default is TDate + 2 weekdays.
#' Format must be YYYY-MM-DD. 
#' @param currency in which CDS is denominated. 
#' @param types is a string indicating the names of the instruments
#' used for the yield curve. 'M' means money market rate; 'S' is swap
#' rate.
#' @param rates is an array of numeric values indicating the rate of
#' each instrument.
#' @param expiries is an array of characters indicating the maturity
#' of each instrument.
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
#' @param tenor of contract. By default is set as 5
#' @param parSpread CDS par spread in bps.
#' @param coupon quoted in bps. It specifies the payment amount from
#' the protection buyer to the seller on a regular basis. The default
#' is 100 bps.
#' @param recoveryRate in decimal. Default is 0.4.
#' @param upfront is quoted in the currency amount. Since a standard
#' contract is traded with fixed coupons, upfront payment is
#' introduced to reconcile the difference in contract value due to the
#' difference between the fixed coupon and the conventional par
#' spread. There are two types of upfront, dirty and clean. Dirty
#' upfront, a.k.a. Cash Settlement Amount, refers to the market value
#' of a CDS contract. Clean upfront is dirty upfront less any accrued
#' interest payment, and is also called the Principal.
#' @param ptsUpfront is quoted as a percentage of the notional
#' amount. They represent the upfront payment excluding the accrual
#' payment. High Yield (HY) CDS contracts are often quoted in points
#' upfront. The protection buyer pays the upfront payment if points
#' upfront are positive, and the buyer is paid by the seller if the
#' points are negative.
#' @param isPriceClean refers to the type of upfront calculated. It is
#' boolean. When \code{TRUE}, calculate principal only. When
#' \code{FALSE}, calculate principal + accrual.
#' @param notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' @param payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' @param convention a named vector which contains all the 12 conventional
#' parameters: mmDCC, calendar, fixedSwapDCC, floatSwapDCC, fixedSwapFreq,
#' floatSwapFreq, holidays, dccCDS, badDayConvCDS,
#' and badDayConvZC with their default values
#' 
#' @return a \code{CDS} class object including the input informtion on
#' the contract as well as the valuation results of the contract.
#' 
#' @export
#' @examples
#' # Build a simple CDS class object
#' require(CDS)
#' cds <- CDS(TDate = as.Date("2014-05-07"), tenor = 5, parSpread = 50, coupon = 100) 

CDS <- function(contract = "SNAC", 
                entityName = NULL,
                RED = NULL,
                
                TDate = Sys.Date(),
                
                ## IR curve dates
                
                baseDate = as.Date(TDate) + 2,
                currency = "USD",
                types = NULL,
                rates = NULL,
                expiries = NULL,
                
                ## CDS 
                
                valueDate = NULL,
                benchmarkDate = NULL,
                startDate = NULL,
                endDate = NULL,
                stepinDate = NULL,
                maturity = NULL,
                tenor = NULL,
                
                parSpread = NULL,
                coupon = 100,
                recoveryRate = 0.4,
                upfront = NULL,
                ptsUpfront = NULL,
                isPriceClean = FALSE,
                notional = 1e7,
                payAccruedOnDefault = TRUE,
                
                ## convention
                
                convention = as.vector(data.frame(mmDCC = "ACT/360",
                                                   calendar = "None",
                                                   fixedSwapDCC = "30/360",
                                                   floatSwapDCC = "ACT/360",
                                                   fixedSwapFreq = "6M",
                                                   floatSwapFreq = "3M",
                                                   holidays = "None",
                                                   dccCDS = "ACT/360",
                                                   
                                              
                                                   badDayConvCDS = "F",
                                                   badDayConvZC = "M"))
){
  
  ## stop if date is invalid

  stopifnot(is.character(contract))
  stopifnot(is.character(currency))
  
  
  ## if none of the three are entered
  
  if ((is.null(upfront)) & (is.null(ptsUpfront)) & (is.null(parSpread)))
    stop("Please input spread, upfront or pts upfront")
  
  ## for JPY, the baseDate is TDate + 2 bus days, whereas for the rest it is TDate + 2 weekdays
  
  baseDate <- JPY.condition(baseDate = baseDate, TDate = TDate, 
                            currency = currency)
  
  ## rates Date is the date for which interest rates will be calculated. get.rates 
  ## function will return the rates of the previous day
  
  effectiveDate <- TDate
  
  ## if maturity date is not given we use the tenor and vice-versa, to get dates using
  ## get.date function. Results are stored in cdsdates
  
  if(is.null(maturity)){
    cdsDates <- get.date(date = as.Date(TDate), tenor = tenor, maturity = NULL)
  } else{
    if(is.null(tenor)){
      cdsDates <- get.date(date = as.Date(TDate), 
                           tenor = NULL, maturity = as.Date(maturity))
    }
    ## if both are entered, we arbitrarily use one of them
    if((!is.null(tenor) & !is.null(maturity))){
      cdsDates <- get.date(date = as.Date(TDate), 
                           tenor = NULL, maturity = as.Date(maturity))
    }
  }
  
  ## if these dates are not entered, we extract that from cdsdates
  
  if (is.null(valueDate)) valueDate         <- as.Date(cdsDates$valueDate)
  if (is.null(benchmarkDate)) benchmarkDate <- as.Date(cdsDates$startDate)
  if (is.null(startDate)) startDate         <- as.Date(cdsDates$startDate)
  if (is.null(endDate)) endDate             <- as.Date(cdsDates$endDate)
  if (is.null(stepinDate)) stepinDate       <- as.Date(cdsDates$stepinDate)
  if (is.null(maturity)) maturity           <- as.Date(cdsDates$endDate)
  
  ## stop if the number of interest rates is not the same as number of expiries
  
  stopifnot(all.equal(length(rates), length(expiries), nchar(types)))  
  
  ## if the rates are not entered, we extract them using get.rates, and store them
  ## in ratesinfo 
  
  if ((is.null(types) | is.null(rates) | is.null(expiries))){
    
    ratesInfo     <- get.rates(date = TDate, currency = currency)
    effectiveDate <- as.Date(as.character(ratesInfo[[2]]$effectiveDate))
    
    ## extract relevant variables like mmDCC, expiries from the get.rates function 
    ## if they are not entered
    
    if (is.null(types)) types       <- paste(as.character(ratesInfo[[1]]$type), collapse = "")
    if (is.null(rates)) rates       <- as.numeric(as.character(ratesInfo[[1]]$rate))
    if (is.null(expiries)) expiries <- as.character(ratesInfo[[1]]$expiry)
    if (is.null(convention['mmDCC'])) convention['mmDCC']       <- as.character(ratesInfo[[2]]$mmDCC)
    
    if (is.null(convention['fixedSwapFreq'])){ 
      convention['fixedSwapFreq'] <- as.character(ratesInfo[[2]]$fixedFreq)}
    if (is.null(convention['floatSwapFreq'])){ 
      convention['floatSwapFreq'] <- as.character(ratesInfo[[2]]$floatFreq)}
    if (is.null(convention['fixedSwapDCC'])){ 
      convention['fixedSwapDCC']   <- as.character(ratesInfo[[2]]$fixedDCC)}
    if (is.null(convention['floatSwapDCC'])){ 
      convention['floatSwapDCC']   <- as.character(ratesInfo[[2]]$floatDCC)}
    if (is.null(convention['badDayConvZC'])){ 
      convention['badDayConvZC']   <- as.character(ratesInfo[[2]]$badDayConvention)}
    if (is.null(convention['holidays'])){ 
      convention['holidays']       <- as.character(ratesInfo[[2]]$swapCalendars)}
  }
  
  ## if entity name and/or RED code is not provided, we set it as NA
  
  if (is.null(entityName)) entityName <- "NA"
  
  if (is.null(RED)) RED <- "NA"
  
  ## create object of class CDS using the data we extracted
  
  cds <- new("CDS",
             contract = contract,
             entityName = entityName,
             RED = RED,
             TDate = TDate,
             baseDate = baseDate,
             currency = currency,
             
             types = types,
             rates = rates,
             expiries = expiries,
             
             effectiveDate = effectiveDate,
             valueDate = valueDate,
             benchmarkDate = benchmarkDate,
             startDate = startDate, 
             endDate = endDate, 
             stepinDate = stepinDate,
             backstopDate = cdsDates$backstopDate,
             firstcouponDate = cdsDates$firstcouponDate,
             pencouponDate = cdsDates$pencouponDate,
             maturity = maturity,
             tenor = as.numeric(tenor),
             
          
             coupon = coupon,
             recoveryRate = recoveryRate,
             inputPriceClean = isPriceClean,
             notional = notional,
             payAccruedOnDefault = payAccruedOnDefault,
             
             convention = convention
  )
  
  ## if parSpread is given, calculate principal and accrual
  
  if (!is.null(parSpread)){
    
    cds@parSpread <- parSpread
    
    ## clean upfront or principal
    
    df <- data.frame(date = c(as.Date(cds@TDate)),
                     spread = c(parSpread),
                     coupon = c(cds@coupon),
                     maturity = c(cds@maturity),
                     currency = c(cds@currency),
                     recovery = c(cds@recoveryRate))
    
    ratesdf <- data.frame(date = as.Date(cds@TDate), currency = cds@currency,
                          expiries = expiries, rates = rates)
    
    cds@principal <- upfront(x = df, rates = ratesdf, notional = cds@notional,
                               isPriceClean = TRUE)
    
    ## points upfront
    
    cds@ptsUpfront <- cds@principal / notional
    
    ## dirty upfront
    
    cds@upfront <- upfront(x = df, rates = ratesdf, notional = cds@notional,
                             isPriceClean = FALSE)
  } else if (!is.null(ptsUpfront)){
    
    ## points upfront
    
    cds@ptsUpfront <- ptsUpfront
    
    ## calculate par spread if not provided
    
    cds@parSpread <- spread(TDate = TDate,
                            baseDate = baseDate,
                            currency = currency,
                            types = types,
                            rates = rates,
                            expiries = expiries,
                            mmDCC = convention['mmDCC'],
                            fixedSwapFreq = convention['fixedSwapFreq'],
                            floatSwapFreq = convention['floatSwapFreq'],
                            fixedSwapDCC = convention['fixedSwapDCC'],
                            floatSwapDCC = convention['floatSwapDCC'],
                            badDayConvZC = convention['badDayConvZC'],
                            holidays = convention['holidays'],
                            valueDate = valueDate,
                            benchmarkDate = benchmarkDate,
                            startDate = startDate,
                            endDate = endDate,
                            stepinDate = stepinDate,
                            maturity = maturity,
                            dccCDS = convention['dccCDS'],
                            freqCDS = "Q",
                            stubCDS = "F",
                            badDayConvCDS = convention['badDayConvCDS'],
                            calendar = convention['calendar'],
                            upfront = upfront,
                            ptsUpfront = ptsUpfront,
                            coupon = coupon, 
                            recoveryRate = recoveryRate,
                            payAccruedAtStart = isPriceClean,
                            notional = notional,
                            payAccruedOnDefault = payAccruedOnDefault)
    
    ## calculate principal or clean upfront using ptsUpfront
    
    cds@principal <- notional * ptsUpfront
    
    ## calculate  dirty upfront
    
    df <- data.frame(date = c(as.Date(cds@TDate)),
                     spread = c(parSpread),
                     coupon = c(cds@coupon),
                     maturity = c(cds@maturity),
                     currency = c(cds@currency),
                     recovery = c(cds@recoveryRate))
    
    ratesdf <- data.frame(date = as.Date(cds@TDate), currency = cds@currency,
                          expiries = expiries, rates = rates)
    
    cds@principal <- upfront(x = df, rates = ratesdf, notional = cds@notional,
                               isPriceClean = FALSE)
    
  } 
  
  ## if pts upfront and parspread are both provided, then we have to calculate the spread
  
  else {        
    if (isPriceClean == TRUE) {
      
      ## principal or clean upfront
      
      cds@principal <- upfront
      
      ## points upfront
      
      cds@ptsUpfront <- upfront / notional
      
      ## calculate parSpread if only clean upfront (principal) and ptsUpfront are provided
      
      cds@parSpread <- spread(TDate = TDate,
                              baseDate = baseDate,
                              currency = currency,
                              types = types,
                              rates = rates,
                              expiries = expiries,
                              mmDCC = convention['mmDCC'],
                              fixedSwapFreq = convention['fixedSwapFreq'],
                              floatSwapFreq = convention['floatSwapFreq'],
                              fixedSwapDCC = convention['fixedSwapDCC'],
                              floatSwapDCC = convention['floatSwapDCC'],
                              badDayConvZC = convention['badDayConvZC'],
                              holidays = convention['holidays'],
                              valueDate = valueDate, 
                              benchmarkDate = benchmarkDate, 
                              startDate = startDate, 
                              endDate = endDate,
                              stepinDate = stepinDate,
                              maturity = maturity,
                              tenor = tenor,
                              dccCDS = convention['dccCDS'],
                              freqCDS = "Q",
                              stubCDS = "F",
                              badDayConvCDS = convention['badDayConvCDS'],
                              calendar = convention['calendar'],
                              upfront = NULL,
                              ptsUpfront = cds@ptsUpfront,
                              coupon = coupon,
                              recoveryRate = recoveryRate,
                              payAccruedAtStart = TRUE,
                              payAccruedOnDefault = payAccruedOnDefault,
                              notional = notional)
      
      ## dirty upfront
      
      df <- data.frame(date = c(as.Date(cds@TDate)),
                       spread = c(parSpread),
                       coupon = c(cds@coupon),
                       tenor = c(cds@tenor),
                       currency = c(cds@currency),
                       recovery = c(cds@recoveryRate))
      
      ratesdf <- data.frame(date = as.Date(cds@TDate), currency = cds@currency,
                            expiries = expiries, rates = rates)
      
      cds@principal <- upfront(x = df, rates = ratesdf, notional = cds@notional,
                                 isPriceClean = FALSE)
      
      
    } else {
      
      ## dirty upfront
      
      cds@upfront <- upfront
      
      ## par Spread
      
      cds@parSpread <- spread(TDate = TDate,
                              baseDate = baseDate,
                              currency = currency,
                              types = types,
                              rates = rates,
                              expiries = expiries,
                              mmDCC = convention['mmDCC'],
                              fixedSwapFreq = convention['fixedSwapFreq'],
                              floatSwapFreq = convention['floatSwapFreq'],
                              fixedSwapDCC = convention['fixedSwapDCC'],
                              floatSwapDCC = convention['floatSwapDCC'],
                              badDayConvZC = convention['badDayConvZC'],
                              holidays = convention['holidays'],
                              valueDate = valueDate, 
                              benchmarkDate = benchmarkDate, 
                              startDate = startDate, 
                              endDate = endDate,
                              stepinDate = stepinDate,
                              maturity = maturity,
                              tenor = tenor,
                              dccCDS = convention['dccCDS'],
                              freqCDS = "Q",
                              stubCDS = "F",
                              badDayConvCDS = convention['badDayConvCDS'],
                              calendar = convention['calendar'],
                              upfront = upfront,
                              ptsUpfront = NULL,
                              coupon = coupon,
                              recoveryRate = recoveryRate,
                              payAccruedAtStart = FALSE,
                              notional = notional,
                              payAccruedOnDefault = payAccruedOnDefault)
      
      ## principal
      
      df <- data.frame(date = c(as.Date(cds@TDate)),
                       spread = c(parSpread),
                       coupon = c(cds@coupon),
                       maturity = c(cds@maturity),
                       currency = c(cds@currency),
                       recovery = c(cds@recoveryRate))
      
      ratesdf <- data.frame(date = as.Date(cds@TDate), currency = cds@currency,
                            expiries = expiries, rates = rates)
      
      cds@principal <- upfront(x = df, rates = ratesdf, notional = cds@notional,
                                 isPriceClean = TRUE)
      
      ## ptsUpfront
      
      cds@ptsUpfront <- cds@principal / notional
    }
  }
  
  ## accrual amount
  
  cds@accrual <- cds@upfront - cds@principal
  
  ## if tenor is NULL, we determine the tenor using the maturity date

  if(is.null(tenor)){

      lt1 <- as.POSIXlt(as.Date(TDate, origin="1900-01-01"))
      monnb1 <- lt1$year*12 + lt1$mon
      
      lt2 <- as.POSIXlt(as.Date(maturity, origin="1900-01-01"))
      monnb2 <- lt2$year*12 + lt2$mon
      
      tenor.mondf <- monnb2 - monnb1
      
      cds@tenor <- as.numeric(tenor.mondf)/12
  }
  
  ## if maturity date is NULL, we set maturity date as the endDate, which obtained using get.date.
  
  if(is.null(maturity)){
    cds@maturity = endDate
  }
  
  ## spreadDV01, IRDV01, RecRisk01, default probability, default exposure and price 
  ## note: this is a hack; must fix
  
  x <- data.frame(date = c(as.Date(cds@TDate)),
                  currency = c(cds@currency),
                  tenor = c(cds@tenor),
                  spread = c(parSpread),
                  coupon = c(cds@coupon),
                  recoveryRate = c(cds@recoveryRate),
                  notional = c(cds@notional))
  
  cds@spreadDV01  <- spread.DV01(x)
  cds@IRDV01      <- IR.DV01(x) 
  cds@RecRisk01   <- rec.risk.01(x)
  cds@defaultProb <- spread.to.pd(spread = cds@parSpread,
                                 time = as.numeric(as.Date(endDate) -
                                                  as.Date(TDate))/360,
                                 recovery.rate = recoveryRate)
  
  ## calculate the default exposure of a CDS contract based on the
  ## formula: Default Exposure: (1-Recovery Rate)*Notional - Principal
  
  cds@defaultExpo <- (1-recoveryRate) * notional - cds@principal

  cds@price       <- (1 - cds@principal / notional) * 100
  
  ## return object with all the calculated data
  
  return(cds)
  
}