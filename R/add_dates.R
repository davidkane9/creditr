#' Return CDS dates.
#' 
#' \code{add_dates} takes a data frame which contains dates, tenor (or maturity)
#' and currency and returns appropriate dates for pricing a CDS contract.
#' 
#' @param x a data frame, containing all necessary information
#' @param date.var character, column name of date variable
#' @param maturity.var character, column name of maturity variable
#' @param tenor.var character, column name of tenor variable
#' @param currency.var character, column name of currency variable
#'   
#' @return a date frame containing all the input columns, as well as eight more 
#'   columns: stepinDate (T+1), valueDate (T+3 business days), startDate 
#'   (accrual begin date), endDate (maturity), backstopDate (T-60 day look back 
#'   from which 'protection' is effective), firstcouponDate (the date on which 
#'   the first coupon is paid), pencouponDate (second to last coupon date), and 
#'   baseDate (the starting date for the IR curve)
#'   
#' @references 
#' \url{http://www.cdsmodel.com/cdsmodel/assets/cds-model/docs/c-code%20Key%20Functions-v1.pdf
#' } 
#' \url{http://www.cdsmodel.com/assets/cds-model/docs/Standard%20CDS%20Examples.pdf
#' }
#' 
#' @examples
#' x <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")),
#'                 tenor = rep(5, 2), currency = c("JPY", "USD"))
#' add_dates(x)

add_dates <- function(x, 
                      date.var     = "date",
                      maturity.var = "maturity",
                      tenor.var    = "tenor",
                      currency.var = "currency"){
  
  has.maturity.var <- !(is.null(maturity.var) || is.null(x[[maturity.var]]))
  has.tenor.var <- !(is.null(tenor.var) || is.null(x[[tenor.var]]))
  stopifnot(xor(has.maturity.var, has.tenor.var))
  
  ## Coerce to desired classes
  
  x[[currency.var]] <- as.character(x[[currency.var]])
  x[[date.var]] <- as.Date(x[[date.var]])
  
  ## List of Japanese holidays through 2020. These dates are necessary in 
  ## determining the interest rate curves. If the trade date (T) lies on the day
  ## before a holiday we won't use the curve on T-1, but the last business day, 
  ## which in this case will be T-2 (assuming T-2 is also a weekday)
  
  ## https://www.markit.com/news/JPY.holidays
  
  JPY.holidays <- as.Date(
    c("2009-03-20", "2009-09-21", "2009-09-22", "2009-09-23", 
      "2010-03-22", "2010-09-20", "2011-03-21", "2012-03-20",
      "2013-03-20", "2015-09-21", "2015-09-22", "2015-09-23", 
      "2016-03-21", "2017-03-20", "2020-03-20", "2020-09-21", "2020-09-22")
    )
  
  ## Use holidayNYSE from timeDate package to get relevant holidays across the years we care about.
  years.of.interest <- range(as.numeric(format(x[[date.var]], "%Y")))
  USD.holidays <- as.Date(holidayNYSE((years.of.interest[1]-1):(years.of.interest[2]+1)))
  
  x$stepinDate      <- as.Date(NA)
  x$valueDate       <- as.Date(NA)
  x$startDate       <- as.Date(NA)  ## also called as Accrual Start Date
  x$firstcouponDate <- as.Date(NA)
  x$pencouponDate   <- as.Date(NA)
  x$endDate         <- as.Date(NA)  ## also called maturity (date)
  x$backstopDate    <- as.Date(NA)
  x$baseDate        <- as.Date(NA)
  
  ## stop if the maturity date does not belong to the Date class
  
  stopifnot(!has.maturity.var || inherits(x[[maturity.var]], "Date"))
  
  for(i in 1:nrow(x)){
    
    ## find out which date is trade date so that we can determine baseDate
    
    dateWday <- as.POSIXlt(x[[date.var]][i])$wday
    
    ## baseDate is the confusing  because of JPY's difference
    
    ## Also notice that the below code is not perfect; if extreme cases like 
    ## five holidays in a row happen, the below code will fail if inaccuracy 
    ## problem (compared with Bloomberg) still happens, ALWAYS re-consider 
    ## problems in baseDate and valueDate FIRST!!!
    
    if(x[[currency.var]][i] == "JPY"){
      
      baseDate <- adj_next_bus_day(x[[date.var]][i] + 1)
      while(baseDate %in% JPY.holidays){
        baseDate <- adj_next_bus_day(baseDate + 1)
      }
      
      baseDate <- adj_next_bus_day(baseDate + 1)
      while(baseDate %in% JPY.holidays){
        baseDate <- adj_next_bus_day(baseDate + 1)
      }
    } else if(x[[currency.var]][i] == "USD"){
      
      baseDate <- adj_next_bus_day(x[[date.var]][i] + 1)
      while(baseDate %in% USD.holidays){
        baseDate <- adj_next_bus_day(baseDate + 1)
      }
      
      baseDate <- adj_next_bus_day(baseDate + 1)
      while(baseDate %in% USD.holidays){
        baseDate <- adj_next_bus_day(baseDate + 1)
      }
    } else{   
      baseDate <- adj_next_bus_day(x[[date.var]][i] + 1)
      baseDate <- adj_next_bus_day(baseDate + 1)
    }
    
    ## stepinDate is the date on which a party assumes ownership of a trade
    ## side. it is Trade date + 1 day
    
    stepinDate <- x[[date.var]][i] + 1
    
    ## valueDate is the date on which a cash payment is settled. valueDate is 3
    ## business days after the Trade Date.
    
    ## Also be aware that, if you check ISDA documentation on valueDate, it will
    ## give you two ways of calculation calculating the valueDate. Remember that
    ## we are using valueDate here for calculating upfront with spread or
    ## calculating spread with upfront, so valueDate in our code = trade date +
    ## 3 business day. (Don't bother looking at the valueDate = trade date + 2
    ## weekday/business day stuff; it's for building the yield curve.)
    
    ## IMPORTANT ERROR OF VALUEDATE: if valueDate is 3 "business" days after the
    ## Trade Date, then shouldn't we consider US, EUR and JP holidays as well?
    ## but we don't have the data frame now for these holidays! The below code
    ## only plus three weekdays to valueDate! this is wrong!!!
    
    valueDate <- adj_next_bus_day(x[[date.var]][i] + 1)
    for(j in 1:2){valueDate <- adj_next_bus_day(valueDate + 1)}
    
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
    
    ## Accrual Start Date must be a weekday. If the rolldate before trade date
    ## is a weekend day, accrual start date must be adjusted to next business
    ## day.
    
    startDate <- adj_next_bus_day(as.Date(as.POSIXct(date.first)))
    
    ## firstcouponDate is the roll date after the startDate.
    ## it has to be a business day. So if the roll date happens to
    ## be Sunday, June 20, the firstCouponDate will be Monday, June 21.
    
    firstcouponDate     <- as.POSIXlt(startDate)
    firstcouponDate$mon <- firstcouponDate$mon + 3
    firstcouponDate     <- as.Date(adj_next_bus_day(firstcouponDate))
    
    ## endDate is the maturity date of the contract or the date up till when 
    ## protection is offered. It is the firstCouponDate + tenor. So if the 
    ## firstCouponDate is June 20, 2014, the endDate will be June 20, 2019.
    
    ## maturity date (endDate) does not need to be a weekday. It has to be on
    ## one of the roll dates.
    ## Note: As of Dec. 21, 2015, ISDA has changed the roll dates to be semi-annual,
    ## restricting them to March 20 and Sept 20.
    ## http://www2.isda.org/asset-classes/credit-derivatives/single-name-cds-roll/
    
    if (has.tenor.var) {
      length       <- x[[tenor.var]][i]
      endDate      <- date.first
      
      ## Handling both the year/multi-year CDS and the 6 month CDS
      if (length >= 1) {
        endDate$year <- date.first$year + length
        endDate$mon <- ifelse(endDate$mon %in% c(2, 5), 5, 11)
      } else {
        endDate$mon <- ifelse(endDate$mon %in% c(2, 5), 11, 5)
        endDate$year <- date.first$year + ((endDate$mon + length * 12) / 12)
      }
      
      endDate      <- as.Date(endDate)
    }
    else{
      
      ## if the maturity date is provided, it is the endDate.
      
      endDate <- as.Date(x[[maturity.var]][i])
    }
    
    ## pencouponDate is the date of the penultimate coupon payment, and it
    ## lies on the roll date right before the maturity date. So if the 
    ## maturity date is June 20, the penultimate coupon date will be March 20.
    
    pencouponDate     <- as.POSIXlt(endDate)
    pencouponDate$mon <- pencouponDate$mon - 3
    pencouponDate     <- as.Date(adj_next_bus_day(pencouponDate))
    
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
  
  ## Accrual End Date is also a date defined on ISDA documentation. Although we 
  ## don't use currently use it in our code, I think I may clarify it for 
  ## precaution. Accural End Day does not have to be a weekday: for example, if 
  ## the second coupon payment date is Mon 6/22/2009 (because 6/20/2009 is a 
  ## weekend day), then the Accrual end date is 6/21/2009, a Sunday.
  
  ## Also, we don't have benchmarkDate here in add_dates(). According to ISDA
  ## date convention documentation, benchmark start date is the same as accrual
  ## begin date, this means that benchmarkDate must be a weekday.
  
  return(x)
}