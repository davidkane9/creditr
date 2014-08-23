#' Japanese Dates
#' 
#' \code{JPY.condition} examines whether the currency is JPY, and adjusts base
#'    date accordingly if so
#' 
#' @param currency in which CDS is denominated.
#' @param date is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}. The date format should be in "YYYY-MM-DD".
#' @param baseDate is the start date for the IR curve. Default is date + 2 weekdays.
#' Format must be YYYY-MM-DD.
#' 
#' @return updated \code{baseDate}

JPY.condition <- function(currency = "USD", date, baseDate){
  
  for(i in 1:length(currency)){
    
    if(currency[i] == "JPY"){        
      baseDate[[i]] <- adj.next.bus.day(as.Date(date[i]) + 2)
      data(JPY.holidays, package = "CDS")
      
      ## if base date is one of the Japanese holidays we add another business day to it
      
      if(baseDate[[i]] %in% JPY.holidays){
        baseDate[[i]] <- adj.next.bus.day(as.Date(date[i]) + 1)
      }
    } 
  }
  return(baseDate)
}