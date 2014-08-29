#' Build a \code{CDS} class object given the input about a CDS contract.
#' 
#' @name CDS
#'   
#' @param name is the name of the reference entity. Optional.
#' @param contract is the contract type, default SNAC
#' @param RED alphanumeric code assigned to the reference entity. Optional.
#' @param date is when the trade is executed, denoted as T. Default is
#'   \code{Sys.Date}. The date format should be in "YYYY-MM-DD".
#' @param spread CDS par spread in bps.
#' @param maturity date of the CDS contract.
#' @param tenor of contract. By default is set as 5
#' @param coupon quoted in bps. It specifies the payment amount from the
#'   protection buyer to the seller on a regular basis. The default is 100 bps.
#' @param recovery in decimal. Default is 0.4.
#' @param currency in which CDS is denominated.
#' @param notional is the amount of the underlying asset on which the payments
#'   are based. Default is 1e7, i.e. 10MM.
#' @param upfront is quoted in the currency amount. Since a standard contract is
#'   traded with fixed coupons, upfront payment is introduced to reconcile the
#'   difference in contract value due to the difference between the fixed coupon
#'   and the conventional par spread. There are two types of upfront, dirty and
#'   clean. Dirty upfront, a.k.a. Cash Settlement Amount, refers to the market
#'   value of a CDS contract. Clean upfront is dirty upfront less any accrued 
#'   interest payment, and is also called the Principal.
#'   
#' @return a \code{CDS} class object including the input informtion on the
#'   contract as well as the valuation results of the contract.
#'   
#' @examples
#' cds <- CDS(date = as.Date("2014-05-07"), tenor = 5, spread = 50, coupon = 100) 

CDS <- function(name = NULL,
                contract = "SNAC",
                RED = NULL,
                date = Sys.Date(),
                spread = NULL,
                maturity = NULL,
                tenor = NULL,
                coupon = 100,
                recovery = 0.4,
                currency = "USD",
                notional = 1e7,
                upfront = NULL){
  
  ## if all three of date, tenor and maturity are given as input,
  ## then we need to check if the three are compatible
  
  if(!(is.null(tenor) | is.null(maturity))){
    
    ## maturityshouldbe is the correct maturity given the input date and tenor
    
    maturityshouldbe <- add.dates(data.frame(date = date, tenor = tenor,
                                             currency = currency))$endDate
    
    ## check if the input maturity matches the correct should-be maturity
    
    stopifnot(maturity == maturityshouldbe) 
  }
  
  isPriceClean <- FALSE
  
  payAccruedOnDefault <- TRUE
  
  ## dates
  
  dates <- as.vector(data.frame(effectiveDate = NA,
                                valueDate = NA,
                                benchmarkDate = NA,
                                startDate = NA, 
                                endDate = NA, 
                                stepinDate = NA,
                                backstopDate = NA,
                                firstcouponDate = NA,
                                pencouponDate = NA))
  
  baseDate <- as.Date(date) + 2
  
  ## conventions
  
  conventions <- as.vector(data.frame(mmDCC = "ACT/360",
                                      calendar = "None",
                                      fixedSwapDCC = "30/360",
                                      floatSwapDCC = "ACT/360",
                                      fixedSwapFreq = "6M",
                                      floatSwapFreq = "3M",
                                      holidays = "None",
                                      dccCDS = "ACT/360",
                                      badDayConvCDS = "F",
                                      badDayConvZC = "M"))
  
  ## stop if date is invalid
  
  stopifnot(is.character(contract))
  stopifnot(is.character(currency))
  
  ## if none of the three are entered
  
  if ((is.null(upfront)) & (is.null(spread)))
    stop("Please input spread, upfront or pts upfront")

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
  
  if (is.na(dates['valueDate'])) dates['valueDate']         <- as.Date(cdsDates$valueDate)
  if (is.na(dates['benchmarkDate'])) dates['benchmarkDate'] <- as.Date(cdsDates$startDate)
  if (is.na(dates['startDate'])) dates['startDate']         <- as.Date(cdsDates$startDate)
  if (is.na(dates['endDate'])) dates['endDate']             <- as.Date(cdsDates$endDate)
  if (is.na(dates['stepinDate'])) dates['stepinDate']       <- as.Date(cdsDates$stepinDate)
  if (is.null(maturity)) maturity                           <- as.Date(cdsDates$endDate)
  if (is.null(baseDate)) baseDate                           <- as.Date(cdsDates$baseDate)
  
  dates['effectiveDate'] <- adj.next.bus.day(date)
  
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
             recovery = recovery,
             currency = currency,
             notional = notional)
  
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
  
  ## if spread is given, calculate principal and accrual
  
  if (!is.null(spread)){
    
    cds@spread <- spread
    
    ## clean upfront or principal
    
    df <- data.frame(date     = as.Date(cds@date),
                     spread   = spread,
                     coupon   = cds@coupon,
                     maturity = cds@maturity,
                     currency = cds@currency,
                     recovery = cds@recovery)
    
    cds@principal <- spread.to.upfront(x = df, notional = cds@notional,
                             isPriceClean = TRUE)
    
    ## dirty upfront
    
    cds@upfront <- spread.to.upfront(x = df, notional = cds@notional,
                           isPriceClean = FALSE)
  }
  
  ## if upfront is provided, then we have to calculate the spread
  
  else {        
    if (isPriceClean == TRUE) {
      
      ## principal or clean upfront
      
      cds@principal <- upfront
      
      ## calculate spread if only clean upfront (principal) and ptsUpfront are provided
      
      spreadinput <- data.frame(date = date,
                                currency = currency,
                                coupon = coupon,
                                ptsUpfront =  upfront / notional,
                                recovery = recovery,
                                tenor = tenor)
      
      cds@spread <- upfront.to.spread(x = spreadinput,
                                      notional = notional,
                                      payAccruedAtStart = TRUE,
                                      payAccruedOnDefault = payAccruedOnDefault)
      ## dirty upfront
      
      df <- data.frame(date     = as.Date(cds@date),
                       spread   = spread,
                       coupon   = cds@coupon,
                       tenor    = cds@tenor,
                       currency = cds@currency,
                       recovery = cds@recovery)
      
      cds@principal <- spread.to.upfront(x = df, notional = cds@notional,
                               isPriceClean = FALSE)
      
      
    } else {
      
      ## dirty upfront
      
      cds@upfront <- upfront
      
      ## par Spread
      
      spreadinput <- data.frame(date = as.Date(cds@date),
                                currency = cds@currency,
                                coupon = cds@coupon,
                                upfront = cds@upfront,
                                recovery = cds@recovery,
                                tenor = cds@tenor)
      
      cds@spread <- upfront.to.spread(x = spreadinput,
                                      notional = notional,
                                      payAccruedAtStart = FALSE,
                                      payAccruedOnDefault = payAccruedOnDefault)
      
      ## principal
      
      df <- data.frame(date = as.Date(cds@date),
                       spread = cds@spread,
                       coupon = cds@coupon,
                       maturity = cds@maturity,
                       currency = cds@currency,
                       recovery = cds@recovery)
      
      cds@principal <- spread.to.upfront(x = df, notional = cds@notional,
                               isPriceClean = TRUE)
    }
  }
  
  ## accrual amount
  
  cds@accrual <- cds@upfront - cds@principal
  
  ## spread.DV01, IR.DV01, rec.risk.01, default probability, default exposure and price 
  ## note: this is a hack; must fix
  
  x <- data.frame(date          = as.Date(cds@date),
                  currency      = cds@currency,
                  tenor         = cds@tenor,
                  spread        = cds@spread,
                  coupon        = cds@coupon,
                  recovery = cds@recovery,
                  notional      = cds@notional)
  
  cds@spread.DV01  <- spread.DV01(x)
  cds@IR.DV01      <- IR.DV01(x) 
  cds@rec.risk.01   <- rec.risk.01(x)
  cds@pd <- spread.to.pd(spread = cds@spread,
                                  time = as.numeric(dates['endDate'][[1]] -
                                                      as.Date(date))/360,
                                  recovery = recovery)
  
  ## calculate the default exposure of a CDS contract based on the
  ## formula: Default Exposure: (1-Recovery Rate)*Notional - Principal
  
  cds@price       <- (1 - cds@principal / notional) * 100
  
  ## return object with all the calculated data
  
  return(cds)
}