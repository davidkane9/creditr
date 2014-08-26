#' Check whether inputs from the data frame are valid
#' 
#' \code{check.inputs} checks whether a data frame's inputs are valid. It is a
#' minimum set of checks. Things such as recovery.rate var are not checked,
#' because some functions don't need them as input.
#' 
#' @inheritParams CS10
#' @param spread.var name of column in x containing  spreads in bps.
#' @param date.var column in x containing the date to be used for pricing and
#'   other calculations.
#'   
#' @return a data frame if not stopped by errors.

check.inputs <- function(x,
                         date.var = "date", 
                         currency.var = "currency",
                         maturity.var = "maturity",
                         tenor.var = "tenor",
                         spread.var = "spread",
                         coupon.var = "coupon",
                         notional.var = "notional",
                         RR.var = "recovery.rate"){

  ## check if certain variables are contained in x
  
  stopifnot(c(currency.var, spread.var, coupon.var) %in% names(x))
  
  if(!notional.var %in% names(x)){
    x <- cbind(x, notional = 1e7)
  }
  
  if(!RR.var %in% names(x)){
    x <- cbind(x, recovery.rate = 0.4)
  }
  
  if(!date.var %in% names(x)){
    x <- cbind(x, date = Sys.Date())
  }
  
  if(!(tenor.var %in% names(x) | maturity.var %in% names(x))){
    x <- cbind(x, tenor = 5)
  }
  
  ## check if variables are defined in the correct classes
  
  ## Since R base does not have a is.date function for checking 
  ## whether a variable is of class "Date", we use
  ## inherits() instead. We don't want other packages.
  
  stopifnot(inherits(x[[date.var]], "Date"))
  
  ## check maturity OR tenor
  
  if(maturity.var %in% names(x) & tenor.var %in% names(x)){
    stop("do not provide both maturity and tenor")
  }else if(maturity.var %in% names(x)){
    stopifnot(inherits(x[[maturity.var]], "Dates"))
  }else if(tenor.var %in% names(x)){
    stopifnot(is.numeric(x[[tenor.var]]))
  }else{
    stop("provide either tenor OR maturity")
  }
  
  stopifnot(is.numeric(x[[spread.var]]) & !(is.integer(x[[spread.var]])))
  stopifnot(is.numeric(x[[coupon.var]]) & !(is.integer(x[[coupon.var]])))
  stopifnot(is.numeric(x[[notional.var]]) & !(is.integer(x[[notional.var]])))
  
  ## change the column names anyway
  
  colnames(x)[which(colnames(x) == date.var)] <- "date"
  colnames(x)[which(colnames(x) == currency.var)] <- "currency"
  colnames(x)[which(colnames(x) == maturity.var)] <- "maturity"
  colnames(x)[which(colnames(x) == tenor.var)] <- "tenor"
  colnames(x)[which(colnames(x) == spread.var)] <- "spread"
  colnames(x)[which(colnames(x) == coupon.var)] <- "coupon"
  colnames(x)[which(colnames(x) == RR.var)] <- "recovery.rate"
  colnames(x)[which(colnames(x) == notional.var)] <- "notional" 

  return(x)
}
