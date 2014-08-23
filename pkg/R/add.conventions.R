#' Return accounting conventions
#' 
#' \code{add.conventions} Given a dataframe which contains currency
#' the function returns appropriate accounting conventions used in pricing a CDS contract. 
#' 
#' @param x a dataframe containing all necessary information
#' @param currency.var character column name of currency variable
#' 
#' @return a date frame with 8 other variables: badDayConvention,
#' mmDCC, mmCalendars, fixedDCC, floatDCC, fixedFreq, floatFreq and swapCalendars
#' 
#' @references
#' http://www.cdsmodel.com/cdsmodel/assets/cds-model/docs/c-code%20Key%20Functions-v1.pdf   
#' 
#' @examples
#' x1 <- data.frame(date = as.Date("2014-05-07"), currency = "USD")
#' add.conventions(x1)
#' 
#' x2 <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")), currency = c("USD", "JPY"))
#' add.conventions(x2)

add.conventions <- function(x, currency.var = "currency"){
  
  ## You must provide a currency.
  
  stopifnot(! (is.null(x[[currency.var]])))
  
  badDayConvention <- rep(NA, nrow(x))
  mmDCC            <- rep(NA, nrow(x))
  mmCalendars      <- rep(NA, nrow(x))
  fixedDCC         <- rep(NA, nrow(x))
  floatDCC         <- rep(NA, nrow(x))
  fixedFreq        <- rep(NA, nrow(x))
  floatFreq        <- rep(NA, nrow(x))
  swapCalendars    <- rep(NA, nrow(x))
  
  ret <- cbind(x, badDayConvention, mmDCC, mmCalendars,
               fixedDCC, floatDCC, fixedFreq, floatFreq, swapCalendars)
  
  for(i in 1:nrow(ret)){
    
    ret$badDayConvention[i] <- "M"
    ret$mmDCC[i] <- "ACT/360"
    ret$floatDCC[i] <- "ACT/360"

    if(ret[[currency.var]][i] == "USD"){
      
      ret$mmCalendars[i] <- "none"
      ret$fixedDCC[i] <- "30/360"
      ret$fixedFreq[i] <- "6M"
      ret$floatFreq[i] <- "3M"
      ret$swapCalendars[i] <- "none"
    } else{
      
      if(ret[[currency.var]][i] == "JPY"){
        
        ret$mmCalendars[i] <- "TYO"
        ret$fixedDCC[i] <- "ACT/365"
        ret$fixedFreq[i] <- "6M"
        ret$floatFreq[i] <- "6M"
        ret$swapCalendars[i] <- "TYO"
      } else{
        
        if(ret[[currency.var]][i] == "EUR"){
          
          ret$mmCalendars[i] <- "none"
          ret$fixedDCC[i] <- "30/360"
          ret$fixedFreq[i] <- "1Y"
          ret$floatFreq[i] <- "6M"
          ret$swapCalendars[i] <- "none"
        }
      }
    }
  }
  return(ret)
}