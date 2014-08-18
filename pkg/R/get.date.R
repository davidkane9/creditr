#' Return CDS dates
#' 
#' \code{get.date} returns appropriate dates used in pricing a CDS contract. 
#' 
#' @param date the date for which we are calculating the relevant dates. Must be of class "date".
#' @param maturity date of maturity of the CDS contract. Default is NULL. Must be of class "date"
#' @param tenor numeric tenor of the CDS contract in format like 5, 3. Default
#'   is NULL. Must enter either maturity or tenor, but not both.
#' @param currency of the contract for which we are calculating the relevant dates. The currency affects
#' the calculation of the baseDate as in the case of JPY denominated contracts, the baseDate cannot
#' lie on any of the specific Japanese holidays.
#' 
#' @return a date frame with 8 variables: step-in date (T+1), value date (T+3 business days),
#'   start date (accrual begin date), end date (maturity), backstop date (T-60 
#'   day look back from which 'protection' is effective), pen coupon date 
#'   (second to last coupon date)
#' 
#' @references
#' http://www.cdsmodel.com/cdsmodel/assets/cds-model/docs/c-code%20Key%20Functions-v1.pdf   
#' 
#' @examples
#' get.date(as.Date("2014-05-07"), tenor = 5, maturity = NULL)

get.date <- function(date, maturity = NULL, tenor = NULL, currency = "USD"){
  
  ## You must provide either a maturity or a tenor, but not both.
  
  stopifnot(! (is.null(maturity) & is.null(tenor)))
  stopifnot(   is.null(maturity) | is.null(tenor))
  
  ## stop if the maturity date does not belong to the date class
  
  if(!is.null(maturity)){
    stopifnot(inherits(as.Date(maturity), "Date"))    
  }
  
  length <- tenor
  
  dateWday <- as.POSIXlt(date)$wday
  if (!(dateWday %in% c(1:5))) stop("date must be a weekday")
  
  ## stepinDate is the date on which a party assumes ownership of a trade side. 
  ## it is Trade date + 1 day
  
  stepinDate <- date + 1
  
  ## valueDate is the date on which a cash payment is settled.
  ## valueDate is 3 business days after the Trade Date. 
  
  valueDate <- stepinDate
  for (i in 1:2){valueDate <- adj.next.bus.day(valueDate + 1)}
  
  ## startDate is the date from when the accrued amount is calculated
    
    date.first <- as.POSIXlt(date)
    
    ## get the remainder X after dividing it by 3 and then move back X month
    
    if (date.first$mon %in% c(2, 5, 8, 11)){
      if (date.first$mday < 20)
        date.first$mon <- date.first$mon - 3
    } else { 
      date.first$mon <- date.first$mon - (as.numeric(format(date.first, "%m")) %% 3)
    }
    date.first$mday <- 20
    
    startDate <- adj.next.bus.day(as.Date(as.POSIXct(date.first)))
  
  ## firstcouponDate is the roll date after the startDate.
  ## it has to be a business day. So if the roll date happens to
  ## be Sunday, June 20, the firstCouponDate will be Monday, June 21.
  
  firstcouponDate     <- as.POSIXlt(startDate)
  firstcouponDate$mon <- firstcouponDate$mon + 3
  firstcouponDate     <- as.Date(adj.next.bus.day(firstcouponDate))
  
  ## endDate is the maturity date of the contract or the date up till when
  ## protection is offered. It is the firstCouponDate + tenor. So if the 
  ## firstCouponDate is June 20, 2014, the endDate will be June 20, 2019.
  
  if(is.null(maturity)){
    endDate <- as.POSIXlt(firstcouponDate)
    endDate$year <- endDate$year + length
    endDate <- as.Date(endDate)
  }
  ## if the maturity date is provided, it is the enddate.
  else{
    endDate <- as.Date(maturity)
  }
  
  ## pencouponDate is the date of the penultimate coupon payment, and it
  ## lies on the roll date right before the maturity date. So if the 
  ## maturity date is June 20, the penultimate coupon date will be March 20.
  
  pencouponDate     <- as.POSIXlt(endDate)
  pencouponDate$mon <- pencouponDate$mon - 3
  pencouponDate     <- as.Date(adj.next.bus.day(pencouponDate))
  
  ## backstopDate is the date from which protection is effective.
  ## So if a credit event occured in the 60 days prior to the trade
  ## date, the protection seller has the obligation to make the 
  ## protection payment.
  ## Since 2009 (Big Bang Protocol), the backstop date is 60 days
  ## before the trade date. Prior to 2009, it was TDate-2
  
  backstopDate <- date - 60
  
  return(data.frame(date, stepinDate, valueDate, startDate,
                    firstcouponDate, pencouponDate, endDate, 
                    backstopDate))
  
}
