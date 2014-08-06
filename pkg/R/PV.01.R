#' \code{PV01} to calculate present value 01 or present value of a stream of 1bp payments
#' 
#' @param principal or clean upfront in currency
#' @param parSpread of the CDS contract in basis points
#' @param coupon of the CDS contract in basis points
#' @param notional in currency. By default is 10 million 
#' 
#' @return PV01 using the formula (principal/notional)*(10000/(parSpread-coupon))

PV.01 <- function(principal, parSpread, coupon, notional = 1e7){
  PV01 <- (principal/notional)*(10000/(parSpread-coupon))
  return(PV01)
}