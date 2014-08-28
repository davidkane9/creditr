#' Calculate CS10
#' 
#' \code{CS10} calculates the change in upfront value when the spread rises by 
#' 10%, also known as the CS10 of a contract.
#' 
#' @param x data frame, contains all the relevant columns.
#' @param date.var character, column in x containing date variable.
#' @param currency.var character, column in x containing currency.
#' @param maturity.var character, column in x containing maturity date.
#' @param tenor.var character, column in x containing tenors.
#' @param spread.var character, column in x containing spread in basis points.
#' @param coupon.var character, column in x containing coupon rates in basis 
#'   points. It specifies the payment amount from the protection buyer to the 
#'   seller on an annual basis.
#' @param RR.var character, column in x containing recovery rates. ISDA model 
#'   standard recovery rate asscumption is 0.4.
#' @param notional.var character, column in x containing the amount of the 
#'   underlying asset on which the payments are based.
#'   
#' @return a vector containing the change in upfront in units of currency.var
#'   when spread increase by 10%, for each corresponding CDS contract.
#'   
#' @seealso \link{add.conventions} \link{add.dates} \link{call.ISDA} 
#'          \link{spread.to.upfront} 
#'   
#' @examples 
#' x <- data.frame(date = as.Date(c("2014-04-22", "2014-04-22")),
#'                 currency = c("USD", "EUR"),
#'                 tenor = c(5, 5),
#'                 spread = c(120, 110),
#'                 coupon = c(100, 100),
#'                 recovery.rate = c(0.4, 0.4),
#'                 notional = c(1e7, 1e7))
#' result <- CS10(x)

CS10 <- function(x,
                 date.var     = "date",
                 currency.var = "currency",
                 maturity.var = "maturity",
                 tenor.var    = "tenor",
                 spread.var   = "spread",
                 coupon.var   = "coupon",
                 RR.var       = "recovery.rate",
                 notional.var = "notional",
                 notional     = 1e7){
  
  ## check if certain variables are contained in x
  
  x <- check.inputs(x,
                    date.var = date.var,
                    currency.var = currency.var,
                    maturity.var = maturity.var,
                    tenor.var = tenor.var,
                    spread.var = spread.var,
                    coupon.var = coupon.var,
                    notional.var = notional.var,
                    notional = notional,
                    RR.var = RR.var)

  CS10 <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
  
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x$date[i], currency = x$currency[i])
    
    CS10[i] <- call.ISDA(name = "CS10", x = x[i,], ratesInfo = ratesInfo)
  }
  
  return(CS10)
}