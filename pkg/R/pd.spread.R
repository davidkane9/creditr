#' \code{pd.spread} to calculate spread using the probability of default, time and recovery rate
#' 
#' @param Recovery rate in decimals
#' @param PD probability of default in decimals
#' @param tenor in years
#' @param TDate trade date. By default is the current date
#' @return spread in basis points, calculated by inverting the formula for probability
#' of default given in the Bloomberg Manual

pd.spread <- function(PD, tenor, TDate = Sys.Date(), Recovery = 0.4){
  
  time <- as.numeric((get.date(date = as.Date(TDate), tenor = tenor)$endDate)-as.Date(TDate))/360
  
  spread <- 1e4*(Recovery-1)*log(1-PD)/time
  
  return(spread)
}