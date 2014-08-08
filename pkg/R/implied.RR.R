#' \code{implied.RR} that calculates the implied recovery rate.
#' 
#' Function that uses the ISDA model to calculate the implied recovery
#' rate for cases in which we have a spread and a probability of
#' default (pd).  This takes a data frame of inputs and returns a
#' vector of the same length. If we have a data frame like:
#' id,spread,pd which we pass into a function, this then returns a
#' vector of implied default rates. 
#'
#' @param data dataframe containing the 1. probability of default (pd) over a 
#' a certain time period, 2. id and 3. spread
#' @param spread.var column number of spread
#' @param endDate.var column number of end dates. maturity date. This 
#' is when the contract expires and protection ends. Any default after 
#' this date does not trigger a payment.
#' @param TDate.var column number of Trade dates. is when the trade is 
#' executed, denoted as T. Default is today.
#' @param col.id is the column for the id of the CDS
#' @param pd.var column number of probability of default rates
#' @return implied recovery rate in percentage based on the general approximation 
#' for a probability of default in the Bloomberg manual. The actual calculation uses 
#' a complicated bootstrapping process, so the results may be marginally different.

implied.RR <- function(data, spread.var, pd.var, col.id, endDate.var, TDate.var){
  
  spread <- data[, spread.var]
  endDate <- data[,endDate.var]
  TDate <- data[,TDate.var]
  pd <- data[, pd.var]
  time <- as.numeric(as.Date(endDate) - as.Date(TDate))/360
  
  impRecoveryRate <- c(100+((spread*time/1e2)*(1/log(1-pd))))
  
  return(impRecoveryRate)
  
}
