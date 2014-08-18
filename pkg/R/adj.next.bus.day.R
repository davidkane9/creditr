#' Adjust to Next Business Day
#' 
#' \code{adj.next.bus.day} gets the next business day 
#' following 5D bus day convention.
#'
#' @param date of \code{Date} class.
#' 
#' @return Date adjusted to the following business day

adj.next.bus.day <- function(date){
  
  dateWday <- as.POSIXlt(date)$wday
  
  ## change date to the most recent weekday if necessary
  
  if (dateWday == 0){
    date <- date + 1
  } else if (dateWday == 6) {
    date <- date + 2
  }
  return(date)
}
