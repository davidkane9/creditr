#' \code{pd.to.spread} to calculate spread using the probability of default, tenor and 
#' recovery rate.
#' 
#' @param data dataset containing the recovery rate, tenor (in years), probability
#' of default and trade date.
#' @param recovery.rate.var name of the column containing the recovery rate in decimals.
#' @param pd.var name of the column containing the probability of default in decimals.
#' @param tenor.var name of the column containing the tenor in years.
#' @param date.var name of the column containing the trade date. 
#' 
#' @return vector containing the spread values in basis points, calculated by inverting 
#' the formula for probability of default given in the Bloomberg Manual

pd.to.spread <- function(data, 
                         recovery.rate.var = "recoveryRate", 
                         tenor.var = "tenor", 
                         date.var = "date", 
                         pd.var = "PD"){
  
  ## stop if the required variables are not contained in the data frame 
  
  stopifnot(c(recovery.rate.var, tenor.var, date.var, pd.var) %in% names(data))
  
  ## stop if the variables do not belong to the correct class
  
  #stopifnot(is.numeric(data[[tenor.var]]))
  stopifnot(is.numeric(data[[recovery.rate.var]]))
  stopifnot(is.numeric(data[[pd.var]]))
  stopifnot(inherits(data[[date.var]], "Date"))
  
  ## calculate the exact time from the trade date till the maturity date
  ## Note: this 'time' is different from tenor. Let's say the trade date April 15, 2014
  ## and the tenor is 5 years. Then the maturity date is June 20, 2019. So the time
  ## used to calculate the spread is the time between June 20, 2019 and April 15, 2014,
  ## which is 5.255556 years.
  
  time <- rep(NA, nrow(data))
  
  for(i in 1:nrow(data)){
    time[i] <- as.numeric((get.date(date = data[[date.var]][i], tenor = data[[tenor.var]][i])$endDate)-data[[date.var]][i])/360    
  }
  
  ## calculate the spread by inverting the formula for probability of default
  spread <- 1e4*(data[[recovery.rate.var]]-1)*log(1-data[[pd.var]])/time
  
  return(spread)
}