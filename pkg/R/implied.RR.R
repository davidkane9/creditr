#' Calculates RR
#' 
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
#' a certain tenor period, 2. id and 3. spread
#' @param spread.var name of the column containing the spread
#' @param end.date.var name of the column containing the end dates or maturity dates. 
#' This is when the contract expires and protection ends. Any default after 
#' this date does not trigger a payment.
#' @param date.var name of the column containing the trade dates.
#' @param pd.var name of the column containing the probability of default rates.
#' 
#' @return implied recovery rate in percentage based on the general approximation 
#' for a probability of default in the Bloomberg manual. The actual calculation uses 
#' a complicated bootstrapping process, so the results may be marginally different.

implied.RR <- function(data, 
                       spread.var = "spread", 
                       pd.var = "pd", 
                       end.date.var = "end.date", 
                       date.var = "date"){
  
  ## stop if the required columns are not contained in the data frame
  
  stopifnot(c(spread.var, pd.var, end.date.var, date.var) %in% names(data))
  
  ## stop if the required variables do not belong to the correct classes
  
  stopifnot(is.numeric(data[[spread.var]]))
  stopifnot(is.numeric(data[[pd.var]]))
  stopifnot(inherits(data[[end.date.var]], "Date"))
  stopifnot(inherits(data[[date.var]], "Date"))
  
  ## calculate the tenor of the contract using the end date and start date
  
  tenor <- as.numeric(data[[end.date.var]] - data[[date.var]])/360
  
  ## calculate the implied recovery rate 
  
  x <- c(100+((data[[spread.var]]*tenor/1e2)*(1/log(1-data[[pd.var]]))))
  
  return(x)
  
}
