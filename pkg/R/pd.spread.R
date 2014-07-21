#' function to calculate spread using the probability of default, time and recovery rate
#' 
#' @param R recovery rate in decimals
#' @param PD probability of default in decimals
#' @param time in years
#' @return spread in basis points, calculated by inverting the formula for probability
#' of default given in the Bloomberg Manual


pd.spread <- function(PD, time, Recovery = 0.4){
  spread = 1e4*(Recovery-1)*log(1-PD)/time
  return(spread)
}
