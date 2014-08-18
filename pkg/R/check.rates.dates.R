#' Make sure dates are available
#' 
#' \code{check.rates.dates.R} makes sure the dates in data frame x
#' being used by the upfrontdf function are also present in the
#' rates data frame being entered into the upfrontdf function (if 
#' it is not contained in the rates data frame, the upfrontdf
#' function will be unable to return the upfront value)
#' match with the rates on markit.com for that specific date.
#' 
#' @param x data frame which contains rates for a specific date 
#' @param rates data frame which contains rates and dates
#' @return vector containing true or false to indicate whether
#' that specific trade date in X is contained in rates

check.rates.dates <- function(x, rates){
  contained <- NULL
  for (i in 1:length(x$date)){
    if (as.Date(x$date[i]) %in% unique(rates$date)){
      contained <- c(contained, TRUE)
    } else{
      contained <- c(contained, FALSE)
    }
  }
  return(contained)
}
