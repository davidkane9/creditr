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
#' 
#' @example
#' # creating x data frame with 100 rows. Note that the column names are different from
#' # what they are set by default
#' 
#' x <- data.frame(cleanUpfront = rep(163000, 100),
#'                 parSpread = rep(65, 100),
#'                 couponRate = rep(100, 100),
#'                 notionalAmount = rep(1e7, 100))
#' 
#' # we feed the data frame 'x' into PV.01 and provide the column 
#' # names of the respective variables as they are defined in 'x'
#' 
#' PV.01(x, principal.var = "cleanUpfront", parSpread.var = "parSpread",
#' coupon.var = "couponRate", notional.var = "notionalAmount")

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