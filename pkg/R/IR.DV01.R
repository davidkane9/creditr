#' Calculate IR.DV01
#' 
#' \code{IR.DV01} calculate the amount of change in upfront when there is a
#' 1/1e4 increase in interest rate for a data frame of CDS contracts.
#' 
#' @inheritParams CS10
#'   
#' @seealso \link{call.ISDA}
#'   
#' @return a vector containing the change in upfront when there is a 1/1e4 
#'   increase in interest rate, for each corresponding CDS contract.
#'   
#' @examples 
#' x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#'                 currency = c("USD", "EUR"),
#'                 tenor = c(5, 5),
#'                 spread = c(120, 110),
#'                 coupon = c(100, 100),
#'                 recovery = c(0.4, 0.4),
#'                 notional = c(1e7, 1e7))
#' IR.DV01(x)

IR.DV01 <- function(x,
                    date.var      = "date",
                    currency.var  = "currency",
                    maturity.var  = "maturity",
                    tenor.var     = "tenor",
                    spread.var    = "spread",
                    coupon.var    = "coupon",
                    RR.var        = "recovery",
                    notional.var  = "notional",
                    notional      = 1e7,
                    recovery      = 0.4){
  
  ## check if certain variables are contained in x
  
  x <- check.inputs(x,
                    date.var      = date.var,
                    currency.var  = currency.var,
                    maturity.var  = maturity.var,
                    tenor.var     = tenor.var,
                    spread.var    = spread.var,
                    coupon.var    = coupon.var,
                    notional.var  = notional.var,
                    notional      = notional,
                    RR.var        = RR.var,
                    recovery      = recovery)
 
  IR.DV01 <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
  
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    rates.info <- get.rates(date = x$date[i], currency = x$currency[i])
    
    IR.DV01[i] <- call.ISDA(name = "IR.DV01", x = x[i,], rates.info = rates.info)
  }
  
  return(IR.DV01)
}