#' \code{check.dataframe} checks whether a data frame's inputs are valid.
#' @param x is the data frame containing all the relevant columns.
#' @param TDate.var name of column in x containing dates when the trade 
#' is executed, denoted as T. Default is \code{Sys.Date}  + 2 weekdays.
#' @param currency.var name of column in x containing currencies. 
#' @param maturity.var name of column in x containing maturity dates.
#' @param tenor.var name of column in x containing tenors.
#' @param parSpread.var name of column in x containing  par spreads in bps.
#' @param coupon.var name of column in x containing coupon rates in bps. 
#' It specifies the payment amount from the protection buyer to the seller 
#' on a regular basis.
#' @param recoveryRate.var name of column in x containing recovery 
#' rates in decimal.
#' @param isPriceClean refers to the type of upfront calculated. It is
#' boolean. When \code{TRUE}, calculate principal only. When
#' \code{FALSE}, calculate principal + accrual.
#' @param payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' @param notional.var name of column in x containing the amount of 
#' the underlying asset on which the payments are based. 
#' Default is 1e7, i.e. 10MM.
#' @return a data frame if not stopped by errors.

check.dataframe <- function(x,
                            TDate.var = "dates",
                            currency.var = "currency",
                            maturity.var = "maturity",
                            tenor.var = "tenor",
                            parSpread.var = "spread",
                            coupon.var = "coupon",
                            recoveryRate.var = "recoveryRate",
                            isPriceClean = FALSE,
                            payAccruedOnDefault = TRUE,
                            notional.var = "notional"){

  ## check if certain variables are contained in x
  
  stopifnot(c(TDate.var, currency.var, maturity.var, tenor.var, 
              parSpread.var, coupon.var, recoveryRate.var, notional.var) %in% names(x))
  
  ## check if variables are defined in the correct classes
  
  stopifnot(is.numeric(x[[parSpread.var]]))
  stopifnot(is.numeric(x[[coupon.var]]))
  stopifnot(is.numeric(x[[recoveryRate.var]]))
  stopifnot(is.numeric(x[[notional.var]]))
  
  return(x)
}