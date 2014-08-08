#' \code{CS10.DF} takes a data frame containing the trade date, spread, coupon and tenor to return 
#' the corresponding CS 10 column with the rest of the data frame
#' 
#' @param x data frame containing the trade date, spread, coupon and tenor
#' @param coupon.var name of column in x which contains the spread 
#' @param currency of the contract. By default is "USD".
#' @return original data frame with a column containing the corresponding CS10 values

CS10.df <- function(x, coupon.var = "coupon", currency = "USD"){
  
  ## create CS10 column containing just NAs
  
  CS10 <- rep(NA, nrow(x))
  
  ## coupon column
  
  coupon <- x[[coupon.var]]
  
  for(i in 1:nrow(x)){
    
    ## stop if parameters belong to the correct class
    
    stopifnot(inherits(x$spread[i], "numeric"))
    stopifnot(inherits(coupon[i], "numeric"))
    stopifnot(inherits(x$tenor[i], "numeric"))
    
    ## if none of the four variables are NA, we can calculate the CS10 value
    
    if(!is.na(coupon[i]) & ! !is.na(x$date[i])
     & !is.na(x$tenor[i]) & !is.na(x$spread[i])){
      
      ## we use the corresponding currency for that index.
      ## Note that we are assuming that there are only 4 indices: IG, HY, XO & Main
      
      if(x$index[i]=="IG" | x$index[i]=="HY"){
        currency <- "USD"
      } else {
        currency <- "EUR"
      }
      
      TDate <- as.Date(x$date[i])
      
      ## if the trade date lands on a weekend, we move back to the most recent weekday
      
      if (as.POSIXlt(TDate)$wday==6) {
        TDate <- TDate-1 
      } else if (as.POSIXlt(TDate)$wday==0) {
        TDate <- TDate-2 
      }      
      
      tenor <- as.character(paste(as.character(x$tenor[i]), "Y", sep=""))
      coupon <- as.numeric(x$coupon[i])
      
      ## if calculating the CS10 for a specific contract returns an error, 
      ## we store it as NA. Since we don't want the whole process to stop
      ## when it returns an error, we use try.
      
      value <- try(CS10(CDS(TDate = TDate,
                           tenor = tenor, 
                           parSpread = x$spread[i],
                           coupon = coupon,
                           recoveryRate = 0.4,
                           notional = 1e7,
                           currency = currency)))
      
      if(is(value, "try-error")){
        CS10[i] <- NA
      } else{
        CS10[i] <- value
      }
   }
    
  ## return vector of CS10 values
   
  return(CS10)
}