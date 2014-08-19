#' Return CDS dates
#' 
#' \code{add.dates} Given a dataframe which contains dates, tenor (or maturity) and/or currency
#' the function returns appropriate dates used in pricing a CDS contract. 
#' 
#' @param x a dataframe containing all necessary information
#' @param date.var character column name of date variable
#' @param maturity.var character column name of maturity variable
#' @param tenor.var character column name of tenor variable
#' @param currency.var character column name of currency variable
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
#' x1 <- data.frame(date = as.Date("2014-05-07"), tenor = 5)
#' add.dates(x1)
#' 
#' x2 <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")), tenor = rep(5, 2))
#' add.dates(x2)
#' 
#' x3 <- data.frame(date = as.Date("2014-05-07"), maturity = as.Date("2019-06-20"))
#' add.dates(x3)

add.dates <- function(x, date.var = "date",
                     maturity.var = "maturity",
                     tenor.var = "tenor",
                     currency.var = "currency"){
  
  ## You must provide either a maturity or a tenor, but not both.

  stopifnot(! (is.null(x$maturity) & is.null(x$tenor)))
  stopifnot(is.null(x$maturity) | is.null(x$tenor))
  
  stepinDate <- as.Date(rep(NA, nrow(x)))
  valueDate <- as.Date(rep(NA, nrow(x)))
  startDate <- as.Date(rep(NA, nrow(x)))
  firstcouponDate <- as.Date(rep(NA, nrow(x)))
  pencouponDate <- as.Date(rep(NA, nrow(x)))
  endDate <- as.Date(rep(NA, nrow(x)))
  backstopDate <- as.Date(rep(NA, nrow(x)))
  
  ret <- cbind(x, stepinDate, valueDate, startDate, firstcouponDate, pencouponDate, endDate, backstopDate)
  
  for(i in 1:nrow(ret)){
   
    ## stop if the maturity date does not belong to the date class
    
    if(!is.null(ret$maturity[i])){
      stopifnot(inherits(as.Date(ret$maturity[i]), "Date"))    
    }
    
    length <- ret$tenor[i]
    
    dateWday <- as.POSIXlt(ret$date[i])$wday
    
    ## stepinDate is the date on which a party assumes ownership of a trade side. 
    ## it is Trade date + 1 day
    
    stepinDate <- ret$date[i] + 1
    
    ## valueDate is the date on which a cash payment is settled.
    ## valueDate is 3 business days after the Trade Date. 
    
    valueDate <- stepinDate
    for (j in 1:2){valueDate <- adj.next.bus.day(valueDate + 1)}
    
    ## startDate is the date from when the accrued amount is calculated
    
    date.first <- as.POSIXlt(ret$date[i])
    
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
    
    if(is.null(ret$maturity[i])){
      endDate <- as.POSIXlt(firstcouponDate)
      endDate$year <- endDate$year + length
      endDate <- as.Date(endDate)
    }
    ## if the maturity date is provided, it is the enddate.
    else{
      endDate <- as.Date(ret$maturity[i])
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
    
    backstopDate <- ret$date[i] - 60
    
    ret$stepinDate[i] <- stepinDate
    ret$startDate[i] <- startDate
    ret$firstcouponDate[i] <- firstcouponDate
    ret$pencouponDate[i] <- pencouponDate
    ret$endDate[i] <- endDate
    ret$backstopDate[i] <- backstopDate
    ret$valueDate[i] <- valueDate
  }
  
  return(ret)
  
}