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