#' Calcualte Default Probability with Spread
#' 
#' \code{spread.to.pd} approximates the default probability at time given the 
#' spread
#' 
#' @inheritParams CS10
#'   
#' @return vector containing the probability of default, calculated by using the
#'   formula for probability of default given in the Bloomberg Manual
#'   
#' @seealso \link{pd.to.spread}

spread.to.pd <- function(x, 
                         recovery.var = "recovery", 
                         currency.var = "currency",
                         tenor.var    = "tenor", 
                         date.var     = "date", 
                         spread.var   = "spread"){
    
  stopifnot(is.data.frame(x))
  
  ## stop if the required variables are not contained in the data frame 
  
  stopifnot(c(recovery.var, tenor.var, currency.var, date.var, spread.var) 
            %in% names(x))
  
  ## stop if the variables do not belong to the correct class
  
  stopifnot(is.numeric(x[[tenor.var]]))
  stopifnot(is.numeric(x[[recovery.var]]))
  stopifnot(is.numeric(x[[spread.var]]))
  stopifnot(inherits(x[[date.var]], "Date"))
  
  x <- add.dates(x)
  
  ## calculate the exact time from the trade date till the maturity date Note:
  ## this 'time' is different from tenor. Let's say the trade date April 15,
  ## 2014 and the tenor is 5 years. Then the maturity date is June 20, 2019. So
  ## the time used to calculate the spread is the time between June 20, 2019 and
  ## April 15, 2014, which is 5.255556 years.
  
  time <- as.numeric(x$endDate - x$date)/360
  
  ## Bloomberg Approximation
  
  pd <- 1 - exp(-x[[spread.var]] / 1e4 * time / (1 - x[[recovery.var]]))
    
  return(pd)
}


