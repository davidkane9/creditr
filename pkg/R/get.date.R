#' \code{get.date} returns appropriate dates used in pricing a CDS contract. 
#' 
#' @param date the date for which we are calculating the relevant dates. Must be of class "date".
#' @param maturity date of maturity of the CDS contract. Default is NULL. Must be of class "date"
#' @param tenor character tenor of the CDS contract in format like 5Y. Default
#'   is NULL. Must enter either maturity or tenor, but not both.
#' @return a date frame with 8 variables: step-in date (T+1), value date (T+3 business days),
#'   start date (accrual begin date), end date (maturity), backstop date (T-60 
#'   day look back from which 'protection' is effective), pen coupon date 
#'   (second to last coupon date)
#' @export
#' @examples
#' get.date(as.Date("2014-05-07"), tenor = "5Y", maturity = NULL)

get.date <- function(date, maturity = NULL, tenor = NULL){

  ## You must provide either a maturity or a tenor, but not both.
  
  stopifnot(! (is.null(maturity) & is.null(tenor)))
  stopifnot(   is.null(maturity) | is.null(tenor))
  
  if(!is.null(maturity)){
    stopifnot(inherits(as.Date(maturity), "Date"))    
  }
  else{
    duration <- gsub("[[:digit:]]", "", tenor)  
    if (!(duration %in% c("M", "Y"))) {
        stop ("Tenor must end with 'M' or 'Y' or enter valid date ")      
    } 
    else{
      length <- as.numeric(gsub("[^[:digit:]]", "", tenor))
    }
  }  

    ## trade date is T
  
    dateWday <- as.POSIXlt(date)$wday
    if (!(dateWday %in% c(1:5))) stop("date must be a weekday")
    
    ## stepinDate is T + 1 business day
  
    stepinDate <- date + 1

    ## valueDate is T + 3 business day
  
    valueDate <- stepinDate
    for (i in 1:2){valueDate <- .adj.next.bus.day(valueDate + 1)}
    
    ## startDate is the date from when the accrued amount is calculated
  
    startDate <- .get.first.accrual.date(date)

    ## firstcouponDate the next IMM date approx after
    ## startDate. adjust to bus day
  
    firstcouponDate     <- as.POSIXlt(startDate)
    firstcouponDate$mon <- firstcouponDate$mon + 3
    firstcouponDate     <- as.Date(.adj.next.bus.day(firstcouponDate))
    
    ## endDate firstcouponDate + maturity. IMM dates. No adjustment.
  
    if(is.null(maturity)){
      endDate <- as.POSIXlt(firstcouponDate)
      if (duration == "M"){
        endDate$mon <- endDate$mon + length
      } else {
          endDate$year <- endDate$year + length
        }
      endDate <- as.Date(endDate)
      }
      else{
        
        ## endDate <- as.POSIXlt(firstcouponDate)  
        ## endDate$year <- endDate$year + (as.POSIXlt(maturity)$year - as.POSIXlt(date)$year)
        
        endDate <- as.Date(maturity)
    }
    
    ## pencouponDate T + maturity - 1 accrual interval. adj to bus day
  
    pencouponDate     <- as.POSIXlt(endDate)
    pencouponDate$mon <- pencouponDate$mon - 3
    pencouponDate     <- as.Date(.adj.next.bus.day(pencouponDate))
    
    ## backstopDate is T - 60
  
    backstopDate <- date - 60

    return(data.frame(date, stepinDate, valueDate, startDate,
                      firstcouponDate, pencouponDate, endDate, 
                      backstopDate))
    
}
