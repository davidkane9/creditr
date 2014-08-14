#' \code{JPY.condition} examines whether the currency is JPY, and adjusts base
#'    date accordingly if so
#' 
#' @param currency in which CDS is denominated.
#' @param Tdate is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}. The date format should be in "YYYY-MM-DD".
#' @param baseDate is the start date for the IR curve. Default is TDate + 2 weekdays.
#' Format must be YYYY-MM-DD.
#' 
#' @return updated \code{baseDate}

JPY.condition <- function(currency = currency, 
                          TDate = Tdate, baseDate = baseDate){
  
    if(currency == "JPY"){        
      baseDate <- .adj.next.bus.day(as.Date(TDate) + 2)
      data(JPY.holidays, package = "CDS")
      
      ## if base date is one of the Japanese holidays we add another business day to it
      
      if(baseDate %in% JPY.holidays){
        baseDate <- .adj.next.bus.day(as.Date(TDate) + 1)
      }
    }
  
  return(baseDate)
}