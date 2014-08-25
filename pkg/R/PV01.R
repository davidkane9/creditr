#' Calculate PV01
#' 
#' \code{PV01} to calculate present value 01 or present value of a stream of 1bp payments
#' 
#' @name PV01
#' 
#' @param x data frame containing the principal, spread, coupon and notional
#' @param principal.var name of the column containing the principal or 
#'        clean upfront values of the CDS
#' @param spread.var name of the column containing the CDS contract in basis points
#' @param coupon.var name of the column containing the CDS contract in basis points
#' @param notional.var name of the column containing the notional amount (in currency terms).
#' 
#' @return Vector containing the PV01 values using the formula: 
#' (principal/notional)*(10000/(spread-coupon))

PV.01 <- function(x, 
                  principal.var = "principal", 
                  spread.var = "spread", 
                  coupon.var = "coupon", 
                  notional.var = "notional"){
  
  stopifnot(c(principal.var, spread.var, coupon.var, notional.var) %in% names(x))
  
  principal <- as.numeric(x[[principal.var]])
  notional  <- as.numeric(x[[notional.var]])
  spread <- as.numeric(x[[spread.var]])
  coupon    <- as.numeric(x[[coupon.var]])
  
  PV01 <- (abs(principal)/notional)*(10000/abs(spread-coupon))
  
  return(PV01)
}