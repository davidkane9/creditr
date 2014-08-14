#' Check whether inputs from the data frame are valid
#' 
#' \code{check.inputs} checks whether a data frame's inputs are valid. It
#'      is a minimum set of checks. Things such as recovery.rate var are
#'      not checked, because some functions don't need them as input. 
#' 
#' @param x is the data frame containing all the relevant columns.
#' @param date.var name of column in x containing dates when the trade 
#'        is executed, denoted as T. Default is \code{Sys.Date}  + 2 weekdays.
#' @param currency.var name of column in x containing currencies. 
#' @param maturity.var name of column in x containing maturity dates.
#' @param tenor.var name of column in x containing tenors.
#' @param spread.var name of column in x containing  par spreads in bps.
#' @param coupon.var name of column in x containing coupon rates in bps. 
#'        It specifies the payment amount from the protection buyer to the 
#'        seller on a regular basis.
#' @param notional.var name of column in x containing the amount of 
#'        the underlying asset on which the payments are based. 
#'        Default is 1e7, i.e. 10MM.
#' 
#' @return a data frame if not stopped by errors.

check.inputs <- function(x, ## change "dates" to "date" later
                            date.var = "dates", 
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