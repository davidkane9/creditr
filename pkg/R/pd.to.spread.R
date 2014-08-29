#' Calculate spread with Default Probability
#' 
#' \code{pd.to.spread} to calculate spread using the probability of default,
#' tenor and recovery rate.
#' 
#' @param x dataset containing the recovery rate, tenor (in years), probability 
#'   of default and trade date.
#' @param recovery.var name of the column containing the recovery rate in
#'   decimals.
#' @param pd.var name of the column containing the probability of default in
#'   decimals.
#' @param tenor.var name of the column containing the tenor in years.
#' @param date.var name of the column containing the trade date.
#'   
#' @return vector containing the spread values in basis points, calculated by
#'   inverting the formula for probability of default given in the Bloomberg
#'   Manual

pd.to.spread <- function(x, 
                         recovery.var = "recovery", 
                         tenor.var = "tenor", 
                         date.var = "date", 
                         pd.var = "PD"){
  
  ## stop if the required variables are not contained in the data frame 
  
  stopifnot(c(recovery.var, tenor.var, date.var, pd.var) %in% names(x))
  
  ## stop if the variables do not belong to the correct class
  
  stopifnot(is.numeric(x[[tenor.var]]))
  stopifnot(is.numeric(x[[recovery.var]]))
  stopifnot(is.numeric(x[[pd.var]]))
  stopifnot(inherits(x[[date.var]], "Date"))
  
  ## calculate the exact time from the trade date till the maturity date
  ## Note: this 'time' is different from tenor. Let's say the trade date April 15, 2014
  ## and the tenor is 5 years. Then the maturity date is June 20, 2019. So the time
  ## used to calculate the spread is the time between June 20, 2019 and April 15, 2014,
  ## which is 5.255556 years.
  
  time <- rep(NA, nrow(x))
  
  for(i in 1:nrow(x)){
    
    ## set currency to "USD" so that add.dates can be used properly
    
    time[i] <- as.numeric((add.dates(data.frame(date = x[[date.var]][i], 
    tenor = x[[tenor.var]][i], currency = "USD"))$endDate)-x[[date.var]][i])/360    
  }
  
  ## calculate the spread by inverting the formula for probability of default
  spread <- 1e4*(x[[recovery.var]]-1)*log(1-x[[pd.var]])/time
  
  return(spread)
}
