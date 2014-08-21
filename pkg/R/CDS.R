#' Build a \code{CDS} class object given the input about a CDS
#' contract.
#' 
#' @name CDS
#' 
#' @param name is the name of the reference entity. Optional.
#' @param contract is the contract type, default SNAC
#' @param RED alphanumeric code assigned to the reference entity. Optional.
#' @param date is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}. The date format should be in "YYYY-MM-DD".
#' @param spread CDS par spread in bps.
#' @param maturity date of the CDS contract.
#' @param tenor of contract. By default is set as 5
#' @param coupon quoted in bps. It specifies the payment amount from
#' the protection buyer to the seller on a regular basis. The default
#' is 100 bps.
#' @param recovery.rate in decimal. Default is 0.4.
#' @param currency in which CDS is denominated. 
#' @param isPriceClean refers to the type of upfront calculated. It is
#' boolean. When \code{TRUE}, calculate principal only. When
#' \code{FALSE}, calculate principal + accrual.
#' @param notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' @param payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}. 
#' @param dates named array which contains relevant date data
#' @param baseDate is the start date for the IR curve. Default is date + 2 weekdays.
#' Format must be YYYY-MM-DD. 
#' @param conventions a named vector which contains all the 12 conventional
#' parameters: mmDCC, calendar, fixedSwapDCC, floatSwapDCC, fixedSwapFreq,
#' floatSwapFreq, holidays, dccCDS, badDayConvCDS,
#' and badDayConvZC with their default values
#' @param interest.rates a list which contains types, rates and expiries
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
#' 
#' @return a \code{CDS} class object including the input informtion on
#' the contract as well as the valuation results of the contract.
#' 
#' @export
#' @examples
#' # Build a simple CDS class object
#' require(CDS)
#' cds <- CDS(date = as.Date("2014-05-07"), tenor = 5, spread = 50, coupon = 100) 

CDS <- function(## name stuff
                name = NULL,
                contract = "SNAC", 
                RED = NULL,

                date = Sys.Date(),
                spread = NULL,
                maturity = NULL,
                tenor = NULL,
                coupon = 100,
                recovery.rate = 0.4,
                currency = "USD",
                isPriceClean = FALSE,
                notional = 1e7,
                payAccruedOnDefault = TRUE,
                
                ## dates
                
                dates = as.vector(data.frame(effectiveDate = NA,
                                             valueDate = NA,
                                             benchmarkDate = NA,
                                             startDate = NA, 
                                             endDate = NA, 
                                             stepinDate = NA,
                                             backstopDate = NA,
                                             firstcouponDate = NA,
                                             pencouponDate = NA)),
                baseDate = as.Date(date) + 2,
                
                ## conventions
                
                conventions = as.vector(data.frame(mmDCC = "ACT/360",
                                                   calendar = "None",
                                                   fixedSwapDCC = "30/360",
                                                   floatSwapDCC = "ACT/360",
                                                   fixedSwapFreq = "6M",
                                                   floatSwapFreq = "3M",
                                                   holidays = "None",
                                                   dccCDS = "ACT/360",
                                                   badDayConvCDS = "F",
                                                   badDayConvZC = "M")),
                
                ## interest.rates stuff
                
                interest.rates = list(types = NULL,
                                     rates = NULL,
                                     expiries = NULL),
                ## CDS
                
                upfront = NULL,
                ptsUpfront = NULL             
){
  
  ## stop if date is invalid

  stopifnot(is.character(contract))
  stopifnot(is.character(currency))
  
  
  ## if none of the three are entered
  
  if ((is.null(upfront)) & (is.null(ptsUpfront)) & (is.null(spread)))
    stop("Please input spread, upfront or pts upfront")
  
  ## for JPY, the baseDate is date + 2 bus days, whereas for the rest it is date + 2 weekdays
  
  baseDate <- JPY.condition(baseDate = baseDate, date = date, 
                            currency = currency)
  
  ## rates Date is the date for which interest rates will be calculated. get.rates 
  ## function will return the rates of the previous day

  dates['effectiveDate'] <- date

  ## if maturity date is not given we use the tenor and vice-versa, to get dates using
  ## add.dates function. Results are stored in cdsdates
  
  if(is.null(maturity)){
    cdsDates <- add.conventions(add.dates(data.frame(date = as.Date(date),
                                                     tenor = tenor, currency = currency)))
  } else{
    if(is.null(tenor)){
      cdsDates <- add.conventions(add.dates(data.frame(date = as.Date(date),
                                       maturity = as.Date(maturity),
                                       currency = currency)))
    }
    ## if both are entered, we arbitrarily use one of them
    if((!is.null(tenor) & !is.null(maturity))){
      cdsDates <- add.conventions(add.dates(data.frame(date = as.Date(date),
                                       maturity = as.Date(maturity),
                                       currency = currency)))
    }
  }
  
  ## if these dates are not entered, we extract that from cdsdates
  
  if (is.na(dates['valueDate'])) dates['valueDate']      <- as.Date(cdsDates$valueDate)
  if (is.na(dates['benchmarkDate'])) dates['benchmarkDate'] <- as.Date(cdsDates$startDate)
  if (is.na(dates['startDate'])) dates['startDate']         <- as.Date(cdsDates$startDate)
  if (is.na(dates['endDate'])) dates['endDate']             <- as.Date(cdsDates$endDate)
  if (is.na(dates['stepinDate'])) dates['stepinDate']       <- as.Date(cdsDates$stepinDate)
  if (is.null(maturity)) maturity           <- as.Date(cdsDates$endDate)
  
  ## stop if the number of interest rates is not the same as number of expiries
  
  stopifnot(all.equal(length(interest.rates$rates), length(interest.rates$expiries), nchar(interest.rates$types)))  
  
  ## if the rates are not entered, we extract them using get.rates, and store them
  ## in ratesinfo 
  
  if ((is.null(interest.rates$types) | is.null(interest.rates$rates) | is.null(interest.rates$expiries))){
    
    ratesInfo     <- get.rates(date = date, currency = currency)
    dates['effectiveDate'] <- adj.next.bus.day(date)

    ## extract relevant variables like mmDCC, expiries from the get.rates function 
    ## if they are not entered
    
    ## interest.rates stuff
    
    if (is.null(interest.rates$types)){ 
      interest.rates$types <- paste(as.character(ratesInfo$type), collapse = "")}
    if (is.null(interest.rates$rates)){
      interest.rates$rates <- as.numeric(as.character(ratesInfo$rate))}
    if (is.null(interest.rates$expiries)){
      interest.rates$expiries <- as.character(ratesInfo$expiry)}
    
    ## conventions stuff
    
    if (is.null(conventions['mmDCC'])){
      conventions['mmDCC']    <- as.character(cdsDates$mmDCC)}
    if (is.null(conventions['fixedSwapFreq'])){ 
      conventions['fixedSwapFreq'] <- as.character(cdsDates$fixedFreq)}
    if (is.null(conventions['floatSwapFreq'])){ 
      conventions['floatSwapFreq'] <- as.character(cdsDates$floatFreq)}
    if (is.null(conventions['fixedSwapDCC'])){ 
      conventions['fixedSwapDCC']   <- as.character(cdsDates$fixedDCC)}
    if (is.null(conventions['floatSwapDCC'])){ 
      conventions['floatSwapDCC']   <- as.character(cdsDates$floatDCC)}
    if (is.null(conventions['badDayConvZC'])){ 
      conventions['badDayConvZC']   <- as.character(cdsDates$badDayConvention)}
    if (is.null(conventions['holidays'])){ 
      conventions['holidays']       <- as.character(cdsDates$swapCalendars)}
  }
  
  ## if entity name and/or RED code is not provided, we set it as NA
  
  if (is.null(name)) name <- "NA"
  
  if (is.null(RED)) RED <- "NA"
  
  dates['backstopDate'] <- cdsDates$backstopDate
  dates['firstcouponDate'] <- cdsDates$firstcouponDate
  dates['pencouponDate'] <- cdsDates$pencouponDate
  
  ## create object of class CDS using the data we extracted
  
  cds <- new("CDS",
             
             name = name,
             contract = contract,
             RED = RED,
             
             date = date,
             maturity = maturity,
             tenor = as.numeric(tenor),
             coupon = coupon,
             recovery.rate = recovery.rate,
             currency = currency,
             inputPriceClean = isPriceClean,
             notional = notional,
             payAccruedOnDefault = payAccruedOnDefault,
             
             dates = dates,
             baseDate = baseDate,
             
             conventions = conventions,
             
             interest.rates = interest.rates          
  )
  
  ## if spread is given, calculate principal and accrual
  
  if (!is.null(spread)){
    
    cds@spread <- spread
    
    ## clean upfront or principal
    
    df <- data.frame(date = c(as.Date(cds@date)),
                     spread = c(spread),
                     coupon = c(cds@coupon),
                     maturity = c(cds@maturity),
                     currency = c(cds@currency),
                     recovery = c(cds@recovery.rate))
    
    ratesdf <- data.frame(date = as.Date(cds@date), currency = cds@currency,
                          expiries = interest.rates$expiries, rates = interest.rates$rates)
    
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
    
    cds@spread <- spread(date = date,
                            baseDate = baseDate,
                            currency = currency,
                            types = interest.rates$types,
                            rates = interest.rates$rates,
                            expiries = interest.rates$expiries,
                            mmDCC = conventions['mmDCC'],
                            fixedSwapFreq = conventions['fixedSwapFreq'],
                            floatSwapFreq = conventions['floatSwapFreq'],
                            fixedSwapDCC = conventions['fixedSwapDCC'],
                            floatSwapDCC = conventions['floatSwapDCC'],
                            badDayConvZC = conventions['badDayConvZC'],
                            holidays = conventions['holidays'],
                            valueDate = dates['valueDate'],
                            benchmarkDate = dates['benchmarkDate'],
                            startDate = dates['startDate'],
                            endDate = dates['endDate'],
                            stepinDate = dates['stepinDate'],
                            maturity = maturity,
                            dccCDS = conventions['dccCDS'],
                            freqCDS = "Q",
                            stubCDS = "F",
                            badDayConvCDS = conventions['badDayConvCDS'],
                            calendar = conventions['calendar'],
                            upfront = upfront,
                            ptsUpfront = ptsUpfront,
                            coupon = coupon, 
                            recovery.rate = recovery.rate,
                            payAccruedAtStart = isPriceClean,
                            notional = notional,
                            payAccruedOnDefault = payAccruedOnDefault)
    
    ## calculate principal or clean upfront using ptsUpfront
    
    cds@principal <- notional * ptsUpfront
    
    ## calculate  dirty upfront
    
    df <- data.frame(date = c(as.Date(cds@date)),
                     spread = c(spread),
                     coupon = c(cds@coupon),
                     maturity = c(cds@maturity),
                     currency = c(cds@currency),
                     recovery = c(cds@recovery.rate))
    
    ratesdf <- data.frame(date = as.Date(cds@date), currency = cds@currency,
                          expiries = interest.rates$expiries, rates = interest.rates$rates)
    
    cds@principal <- upfront(x = df, rates = ratesdf, notional = cds@notional,
                               isPriceClean = FALSE)
    
  } 
  
  ## if pts upfront and spread are both provided, then we have to calculate the spread
  
  else {        
    if (isPriceClean == TRUE) {
      
      ## principal or clean upfront
      
      cds@principal <- upfront
      
      ## points upfront
      
      cds@ptsUpfront <- upfront / notional
      
      ## calculate spread if only clean upfront (principal) and ptsUpfront are provided
      
      cds@spread <- spread(date = date,
                              baseDate = baseDate,
                              currency = currency,
                              types = interest.rates$types,
                              rates = interest.rates$rates,
                              expiries = interest.rates$expiries,
                              mmDCC = conventions['mmDCC'],
                              fixedSwapFreq = conventions['fixedSwapFreq'],
                              floatSwapFreq = conventions['floatSwapFreq'],
                              fixedSwapDCC = conventions['fixedSwapDCC'],
                              floatSwapDCC = conventions['floatSwapDCC'],
                              badDayConvZC = conventions['badDayConvZC'],
                              holidays = conventions['holidays'],
                              valueDate = dates['valueDate'], 
                              benchmarkDate = dates['benchmarkDate'], 
                              startDate = dates['startDate'], 
                              endDate = dates['endDate'],
                              stepinDate = dates['stepinDate'],
                              maturity = maturity,
                              tenor = tenor,
                              dccCDS = conventions['dccCDS'],
                              freqCDS = "Q",
                              stubCDS = "F",
                              badDayConvCDS = conventions['badDayConvCDS'],
                              calendar = conventions['calendar'],
                              upfront = NULL,
                              ptsUpfront = cds@ptsUpfront,
                              coupon = coupon,
                              recovery.rate = recovery.rate,
                              payAccruedAtStart = TRUE,
                              payAccruedOnDefault = payAccruedOnDefault,
                              notional = notional)
      
      ## dirty upfront
      
      df <- data.frame(date = c(as.Date(cds@date)),
                       spread = c(spread),
                       coupon = c(cds@coupon),
                       tenor = c(cds@tenor),
                       currency = c(cds@currency),
                       recovery = c(cds@recovery.rate))
      
      ratesdf <- data.frame(date = as.Date(cds@date), currency = cds@currency,
                            expiries = interest.rates$expiries, rates = interest.rates$rates)
      
      cds@principal <- upfront(x = df, rates = ratesdf, notional = cds@notional,
                                 isPriceClean = FALSE)
      
      
    } else {
      
      ## dirty upfront
      
      cds@upfront <- upfront
      
      ## par Spread
      
      cds@spread <- spread(date = date,
                              baseDate = baseDate,
                              currency = currency,
                              types = interest.rates$types,
                              rates = interest.rates$rates,
                              expiries = interest.rates$expiries,
                              mmDCC = conventions['mmDCC'],
                              fixedSwapFreq = conventions['fixedSwapFreq'],
                              floatSwapFreq = conventions['floatSwapFreq'],
                              fixedSwapDCC = conventions['fixedSwapDCC'],
                              floatSwapDCC = conventions['floatSwapDCC'],
                              badDayConvZC = conventions['badDayConvZC'],
                              holidays = conventions['holidays'],
                              valueDate = dates['valueDate'], 
                              benchmarkDate = dates['benchmarkDate'], 
                              startDate = dates['startDate'], 
                              endDate = dates['endDate'],
                              stepinDate = dates['stepinDate'],
                              maturity = maturity,
                              tenor = tenor,
                              dccCDS = conventions['dccCDS'],
                              freqCDS = "Q",
                              stubCDS = "F",
                              badDayConvCDS = conventions['badDayConvCDS'],
                              calendar = conventions['calendar'],
                              upfront = upfront,
                              ptsUpfront = NULL,
                              coupon = coupon,
                              recovery.rate = recovery.rate,
                              payAccruedAtStart = FALSE,
                              notional = notional,
                              payAccruedOnDefault = payAccruedOnDefault)
      
      ## principal
      
      df <- data.frame(date = c(as.Date(cds@date)),
                       spread = c(spread),
                       coupon = c(cds@coupon),
                       maturity = c(cds@maturity),
                       currency = c(cds@currency),
                       recovery = c(cds@recovery.rate))
      
      ratesdf <- data.frame(date = as.Date(cds@date), currency = cds@currency,
                            expiries = interest.rates$expiries, rates = interest.rates$rates)
      
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

      lt1 <- as.POSIXlt(as.Date(date, origin="1900-01-01"))
      monnb1 <- lt1$year*12 + lt1$mon
      
      lt2 <- as.POSIXlt(as.Date(maturity, origin="1900-01-01"))
      monnb2 <- lt2$year*12 + lt2$mon
      
      tenor.mondf <- monnb2 - monnb1
      
      cds@tenor <- as.numeric(tenor.mondf)/12
  }
  
  ## if maturity date is NULL, we set maturity date as the endDate, which obtained using add.dates.
  
  if(is.null(maturity)){
    cds@maturity = dates['endDate']
  }
  
  ## spreadDV01, IRDV01, RecRisk01, default probability, default exposure and price 
  ## note: this is a hack; must fix
  
  x <- data.frame(date = c(as.Date(cds@date)),
                  currency = c(cds@currency),
                  tenor = c(cds@tenor),
                  spread = c(spread),
                  coupon = c(cds@coupon),
                  recovery.rate = c(cds@recovery.rate),
                  notional = c(cds@notional))
  
  cds@spreadDV01  <- spread.DV01(x)
  cds@IRDV01      <- IR.DV01(x) 
  cds@RecRisk01   <- rec.risk.01(x)
  cds@defaultProb <- spread.to.pd(spread = cds@spread,
                                 time = as.numeric(dates['endDate'][[1]] -
                                                  as.Date(date))/360,
                                 recovery.rate = recovery.rate)

  ## calculate the default exposure of a CDS contract based on the
  ## formula: Default Exposure: (1-Recovery Rate)*Notional - Principal
  
  cds@defaultExpo <- (1-recovery.rate) * notional - cds@principal
  cds@price       <- (1 - cds@principal / notional) * 100
  
  ## return object with all the calculated data
  
  return(cds)
}