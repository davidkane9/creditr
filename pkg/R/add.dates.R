#' Return CDS dates.
#' 
#' \code{add.dates} takes a data frame which contains dates, tenor (or maturity) and currency
#' and returns appropriate dates for pricing a CDS contract. 
#' 
#' @param x a data frame, containing all necessary information
#' @param date.var character, column name of date variable
#' @param maturity.var character, column name of maturity variable
#' @param tenor.var character, column name of tenor variable
#' @param currency.var character, column name of currency variable
#' 
#' @return a date frame containing all the input columns, as well as 
#' eight more columns: stepinDate (T+1), valueDate (T+3 business days),
#' startDate (accrual begin date), endDate (maturity), backstopDate (T-60 
#' day look back from which 'protection' is effective), firstcouponDate
#' (the date on which the first coupon is paid), pencouponDate (second 
#' to last coupon date), and baseDate (the starting date for the IR curve)
#' 
#' @references
#' http://www.cdsmodel.com/cdsmodel/assets/cds-model/docs/c-code%20Key%20Functions-v1.pdf   
#' 
#' @examples
#' x <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")),
#' tenor = rep(5, 2), currency = c("JPY", "USD"))
#' add.dates(x)

add.dates <- function(x, 
                      date.var     = "date",
                      maturity.var = "maturity",
                      tenor.var    = "tenor",
                      currency.var = "currency"){
  
  stopifnot(!(is.null(x[[maturity.var]]) & is.null(x[[tenor.var]])))
  stopifnot(is.null(x[[maturity.var]]) | is.null(x[[tenor.var]]))
  
  ## call JPY.holidays data frame for dates settings later
  
  data(JPY.holidays, package = "CDS")
  
  x$baseDate        <- as.Date(NA)
  x$stepinDate      <- as.Date(NA)
  x$valueDate       <- as.Date(NA)
  x$startDate       <- as.Date(NA)
  x$firstcouponDate <- as.Date(NA)
  x$pencouponDate   <- as.Date(NA)
  x$endDate         <- as.Date(NA)
  x$backstopDate    <- as.Date(NA)
  x$baseDate        <- as.Date(NA)
  
  for(i in 1:nrow(x)){
    
    ## stop if the maturity date does not belong to the date class
    
    if(!is.null(x[[maturity.var]][i])){
      stopifnot(inherits(as.Date(x[[maturity.var]][i]), "Date"))    
    }
    
    length <- x[[tenor.var]][i]
    
    ## find out which date is trade date so that we can determine baseDate
    
    dateWday <- as.POSIXlt(x[[date.var]][i])$wday
    
    ## baseDate is the biggest confusing date, because of JPY's difference
    
    ## Also notice that the below code is not perfect; if extreme cases 
    ## like five holidays in a row happen, the below code will fail
    ## if inaccuracy problem (compared with Bloomberg) still happens,
    ## ALWAYS re-consider problems in baseDate and valueDate FIRST!!!
    
    if(x[[currency.var]][i] != "JPY"){
      
      baseDate <- adj.next.bus.day(x[[date.var]][i] + 1)
      baseDate <- adj.next.bus.day(baseDate + 1)
      
    } else{
      
      baseDate <- adj.next.bus.day(x[[date.var]][i] + 1)
      while(baseDate %in% JPY.holidays){
        baseDate <- adj.next.bus.day(baseDate + 1)
      }
      
      baseDate <- adj.next.bus.day(baseDate + 1)
      while(baseDate %in% JPY.holidays){
        baseDate <- adj.next.bus.day(baseDate + 1)
      }
    }
    
    ## stepinDate is the date on which a party assumes ownership of a trade side. 
    ## it is Trade date + 1 day
    
    stepinDate <- x[[date.var]][i] + 1
    
    ## valueDate is the date on which a cash payment is settled.
    ## valueDate is 3 business days after the Trade Date. 
    
    ## if valueDate is 3 "business" days after the Trade Date,
    ## then shouldn't we consider US, EUR and JP holidays as well?
    ## but we don't have the data frame now for these holidays!
    ## The below code only plus three weekdays to valueDate!
    ## this is wrong!!!
    
    valueDate <- adj.next.bus.day(x[[date.var]][i] + 1)
    for(j in 1:2){valueDate <- adj.next.bus.day(valueDate + 1)}
    
    ## startDate is the date from when the accrued amount is calculated
    
    date.first <- as.POSIXlt(x[[date.var]][i])
    
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
    
    if(is.null(x[[maturity.var]][i])){
      endDate <- date.first
      endDate$year <- date.first$year + length
      endDate$mon <- endDate$mon + 3
      endDate <- as.Date(endDate)
    }
    
    ## if the maturity date is provided, it is the endDate.
    
    else{
      endDate <- as.Date(x[[maturity.var]][i])
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
    ## before the trade date. Prior to 2009, it was trade date - 2
    
    backstopDate <- x[[date.var]][i] - 60
    
    x$stepinDate[i]      <- stepinDate
    x$startDate[i]       <- startDate
    x$firstcouponDate[i] <- firstcouponDate
    x$pencouponDate[i]   <- pencouponDate
    x$endDate[i]         <- endDate
    x$backstopDate[i]    <- backstopDate
    x$valueDate[i]       <- valueDate
    x$baseDate[i]        <- baseDate
  }
  
  return(x)
  
}