#' Calculate IR.DV01
#' 
#' \code{IR.DV01} calculate the amount of change in upfront when there is a 1/1e4
#' increase in interest rate for a data frame of CDS contracts.
#'
#' @inheritParams CS10
#' 
#' @seealso \link{add.conventions} \link{add.dates} \link{call.ISDA} \link{upfront}
#' 
#' @return a vector containing the change in upfront when there is a 1/1e4
#' increase in interest rate, for each corresponding CDS contract.
#' 
#' @examples 
#' x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
#' currency = c("USD", "EUR"),
#' tenor = c(5, 5),
#' spread = c(120, 110),
#' coupon = c(100, 100),
#' recovery.rate = c(0.4, 0.4),
#' notional = c(1e7, 1e7))
#' result <- IR.DV01(x)

IR.DV01 <- function(x,
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
  
  ## change the column names anyway
  
  colnames(x)[which(colnames(x) == date.var)] <- "date"
  colnames(x)[which(colnames(x) == currency.var)] <- "currency"
  colnames(x)[which(colnames(x) == maturity.var)] <- "maturity"
  colnames(x)[which(colnames(x) == tenor.var)] <- "tenor"
  colnames(x)[which(colnames(x) == spread.var)] <- "spread"
  colnames(x)[which(colnames(x) == coupon.var)] <- "coupon"
  colnames(x)[which(colnames(x) == RR.var)] <- "recovery.rate"
  colnames(x)[which(colnames(x) == notional.var)] <- "notional" 
  
  IR.DV01 <- rep(NA, nrow(x))
  
  x <- add.conventions(add.dates(x))
  
  for(i in 1:nrow(x)){
    
    ## extract currency specific interest rate data and date conventions using
    ## get.rates()
    
    ratesInfo <- get.rates(date = x$date[i], currency = x$currency[i])
    
    IR.DV01[i] <- call.ISDA(name = "IR.DV01", x = x[i,], ratesInfo = ratesInfo)
  }
  
  return(IR.DV01)
}