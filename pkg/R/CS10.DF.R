#' \code{CS10.DF} takes a data frame containing the trade date, spread, coupon and tenor to return 
#' the corresponding CS 10 column with the rest of the data frame
#' 
#' @param x data frame containing the trade date, spread, coupon and tenor
#' @param coupon.var name of column in x which contains the spread 
#' @param currency of the contract. By default is "USD".
#' @return original data frame with a column containing the corresponding CS10 values

CS10.DF <- function(x, coupon.var = "coupon", currency = "USD"){
  
  ## stop if essential variables are not contained in x
  
  stopifnot(c(spread, coupon.var, tenor, date) %in% names(x))

  ## stop if parameters belong to the correct class
  
  stopifnot(is.numeric(x$spread))
  stopifnot(is.numeric(x[[coupon.var]]))
  stopifnot(is.numeric(x$tenor))
  stopifnot(inherits(x$date, "Date"))
    
  ## create CS10 vector containing just NAs
  
  CS10 <- rep(NA, nrow(x))
  
  for(i in 1:nrow(x)){
    
      TDate <- as.Date(x$date[i])
      
      ## if the trade date lands on a weekend, we move back to the most recent weekday
      
      if (as.POSIXlt(TDate)$wday == 6) {
        TDate <- TDate - 1 
      } else if (as.POSIXlt(TDate)$wday == 0) {
        TDate <- TDate - 2 
      }      
      
      tenor <- as.character(paste(as.character(x$tenor[i]), "Y", sep = ""))
      
      ## if calculating the CS10 for a specific contract returns an error, 
      ## we store it as NA. Since we don't want the whole process to stop
      ## when it returns an error, we use try.
      ## For instance, if any of the four variables are abset, we can
      ## still calculate the CS10 value for the rest      
      
      value <- try(CS10(CDS(TDate = TDate,
                           tenor = tenor, 
                           parSpread = x$spread[i],
                           coupon = x[[coupon.var]][i],
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