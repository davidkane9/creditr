#' \code{get.first.accrual.date} cGet the first accrual date. If it's a weekend, adjust to the
#' following weekday. March/Jun/Sept/Dec 20th
#' 
#' @param TDate of \code{Date} class
#' @return a \code{Date} class object

get.first.accrual.date <- function(TDate){
  
  date <- as.POSIXlt(TDate)
  
  ## get the remainder X after dividing it by 3 and then move back X month
  
  if (date$mon %in% c(2, 5, 8, 11)){
    if (date$mday < 20)
      date$mon <- date$mon - 3
  } else { 
    date$mon <- date$mon - (as.numeric(format(date, "%m")) %% 3)
  }
  date$mday <- 20
  accrualDate <- adj.next.bus.day(as.Date(as.POSIXct(date)))
  
  return(accrualDate)
}
