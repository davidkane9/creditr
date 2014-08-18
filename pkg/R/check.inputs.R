#' Check whether inputs from the data frame are valid
#' 
#' \code{check.inputs} checks whether a data frame's inputs are valid. It
#'      is a minimum set of checks. Things such as recovery.rate var are
#'      not checked, because some functions don't need them as input. 
#' 
#' @inheritParams CS10
#' @param spread.var name of column in x containing  spreads in bps.
#' @param date.var column in x containing dates when the trade 
#' is executed, denoted as T. Default is \code{Sys.Date}  + 2 weekdays.
#' 
#' @return a data frame if not stopped by errors.

check.inputs <- function(x,
                         date.var = "date", 
                         currency.var = "currency",
                         maturity.var = "maturity",
                         tenor.var = "tenor",
                         spread.var = "spread",
                         coupon.var = "coupon",
                         notional.var = "notional"){

  ## check if certain variables are contained in x
  
  stopifnot(c(date.var, currency.var, maturity.var, tenor.var, 
             spread.var, coupon.var, notional.var) %in% names(x))
  
  ## check if variables are defined in the correct classes
  
  ## Since R base does not have a is.date function for checking 
  ## whether a variable is of class "Date", we use
  ## inherits() instead. We don't want other packages.
  
  stopifnot(inherits(x[[date.var]], "Date"))
  
  ## check maturity OR tenor
  
  if(is.null(x[[tenor.var]]) & is.null(x[[maturity.var]])){
    stop("please enter a tenor OR maturity")
  }
  
  
  if(is.null(x[[tenor.var]]) | all(is.na(x[[tenor.var]]))){
    stopifnot(inherits(x[[maturity.var]], "Date"))
  }else if(is.null(x[[maturity.var]]) | all(is.na(x[[maturity.var]]))){
    stopifnot(is.numeric(x[[tenor.var]]))
  }else{
    stopifnot(inherits(x[[maturity.var]], "Date") & is.numeric(x[[tenor.var]]))
  }
  
  stopifnot(is.numeric(x[[spread.var]]))
  stopifnot(is.numeric(x[[coupon.var]]))
  stopifnot(is.numeric(x[[notional.var]]))
  
  return(x)
}
