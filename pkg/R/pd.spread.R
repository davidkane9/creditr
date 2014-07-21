#' function to calculate spread using the probability of default, time and recovery rate
#' 
#' @param R recovery rate
#' @param PD probability of default
#' @param t time
#' @return spread


pd.spread <- function(R = 0.4, PD, t){
  spread = 10000*(R-1)*log(1-PD)/t
  return(spread)
}
