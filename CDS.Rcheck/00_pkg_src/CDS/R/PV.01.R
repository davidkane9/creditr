#' \code{PV01} to calculate present value 01 or present value of a stream of 1bp payments
#' 
#' @name PV01
#' 
#' @param x data frame containing the principal, parSpread, coupon and notional
#' @param principal.var name of the column containing the principal or 
#' clean upfront values of the CDS
#' @param parSpread.var name of the column containing the CDS contract in basis points
#' @param coupon.var name of the column containing the CDS contract in basis points
#' @param notional.var name of the column containing the notional amount (in currency terms).
#' 
#' @return Vector containing the PV01 values using the formula: 
#' (principal/notional)*(10000/(parSpread-coupon))

PV.01 <- function(x, 
                  principal.var = "principal", 
                  parSpread.var = "spread", 
                  coupon.var = "coupon", 
                  notional.var = "notional"){
  
  principal <- as.numeric(x[[principal.var]])
  notional  <- as.numeric(x[[notional.var]])
  parSpread <- as.numeric(x[[parSpread.var]])
  coupon    <- as.numeric(x[[coupon.var]])
  
  PV01 <- (abs(principal)/notional)*(10000/abs(parSpread-coupon))
  
  return(PV01)
}