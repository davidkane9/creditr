#' Calculate RR change
#' 
#' \code{rec.risk.01} calculate the amount of change in upfront when there is a 1%
#' increase in recovery rate for a data frame of CDS contracts.
#'
#' @inheritParams CS10
#' 
#' @seealso \link{add.conventions} \link{add.dates} \link{call.ISDA} 
#'          \link{spread.to.upfront}
#' 
#' @return a vector containing the change in upfront when there is a 1
#'   percent increase in recovery rate, for each corresponding CDS contract.
#' 
#' @examples 
#' x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' tenor = c(5, 5),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recovery.rate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' result <- rec.risk.01(x)

rec.risk.01 <- function(x,
                        date.var     = "date",
                        currency.var = "currency",
                        maturity.var = "maturity",
                        tenor.var    = "tenor",
                        spread.var   = "spread",
                        coupon.var   = "coupon",
                        RR.var       = "recovery.rate",
                        notional.var = "notional"){
  
  ## check if certain variables are contained in x
  
  x <- check.inputs(x, date.var = date.var, currency.var = currency.var,
                    maturity.var = maturity.var, tenor.var = tenor.var,
                    spread.var = spread.var, coupon.var = coupon.var,
                    notional.var = notional.var, RR.var = RR.var)
  
  rec.risk.01 <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
  
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x$date[i], currency = x$currency[i])
    
    rec.risk.01[i] <- call.ISDA(name = "rec.risk.01", x = x[i,], ratesInfo = ratesInfo)
  }
  
  return(rec.risk.01)
}