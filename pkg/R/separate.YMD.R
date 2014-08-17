#' Separate Year/Month/Day
#' 
#' \code{separate.YMD} contains helper functions to separate an input date into
#'  year, month, and day.
#'
#' @param d is an input date.
#' @return an array contains year, month, date of the input date
#' \code{d}.

separate.YMD <- function(d){
  
  ## valueDate format valueDate = "2008-02-01"
  
  dateYear <- as.numeric(format(as.Date(d), "%Y"))
  dateMonth <- as.numeric(format(as.Date(d), "%m"))
  dateDay <- as.numeric(format(as.Date(d), "%d"))
  return(c(dateYear, dateMonth, dateDay))
}