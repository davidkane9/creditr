#' Return accounting conventions
#' 
#' \code{add.conventions} takes a data frame with a currency.var column and returns
#' the same data frame with eight other columns of accounting conventions added to it.
#' 
#' @param x a data frame containing all necessary information
#' @param currency.var a character indicating the name of currency column
#' 
#' @return a data frame with eight more columns of accounting conventions: badDayConvention
#' (a character indicating how non-business days are converted), mmDCC (the day count convention
#' of the instruments), mmCalendars (any calendar adjustment for the CDS), fixedDCC (the day count
#' convention of the fixed leg), floatDCC (the day count convention of the floating leg), fixedFreq
#' (the frequency of the fixed rate of swap being paid), floatFreq (the frequency of the floating
#' rate of swap being paid) and swapCalendars (any calendar adjustment for swap rate)
#' 
#' @references
#' http://www.cdsmodel.com/cdsmodel/assets/cds-model/docs/c-code%20Key%20Functions-v1.pdf   
#'
#' @examples 
#' x <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")), currency = c("USD", "JPY"))
#' add.conventions(x)

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