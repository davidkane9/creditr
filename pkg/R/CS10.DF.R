#' function that takes a data frame containing the trade date, spread, coupon and tenor to return 
#' the corresponding CS 10 column with the rest of the data frame
#' 
#' @param x data frame containing the trade date, spread, coupon and tenor 
#' @return original data frame with a column containing the corresponding CS10 values

CS10.df <- function(x){
  
  index <- x$index
  
  ## create CS10 column
  
  CS10 <- NULL
  for(i in 1:nrow(x)){
    
    ## if none of the four variables are NA, we can calculate the CS10 value
    
    if(is.na(x$cma.CouponSpread[i])==FALSE & is.na(x$date[i])==FALSE
     & is.na(x$tenor[i])==FALSE & is.na(x$spread[i])==FALSE){
      
      ## we use the corresponding currency for that index
      
      if(index[i]=="IG" | index[i]=="HY"){
        currency <- "USD"
      } else {
        currency <- "EUR"
      }
      
      TDate <- as.Date(x$date[i])
      if (as.POSIXlt(TDate)$wday==6) {
        TDate <- TDate-1 
      } else if (as.POSIXlt(TDate)$wday==0) {
        TDate <- TDate-2 
      }
      
      
      tenor <- as.character(paste(as.character(x$tenor[i]), "Y", sep=""))
      parSpread <- as.numeric(x$spread[i])
      coupon <- as.numeric(x$cma.CouponSpread[i])
      
      value <- try(CS10(CDS(TDate = TDate,
                           tenor = tenor, 
                           parSpread = parSpread,
                           coupon = coupon,
                           recoveryRate = 0.4,
                           notional = 1e7,
                           currency = currency)))
      
      if(is(value, "try-error")){
        CS10 <- c(CS10, NA)
      } else{
        CS10 <- c(CS10, value)
      }

   }
    
    ## if any of the variables are NA, CS10 is stored as NA
    
  else {
      CS10 <- c(CS10, NA)
    }    
  }
  
  return(cbind(x,CS10))
}