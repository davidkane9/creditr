#' Build rates.RData
#' 
#' \code{build.rates} builds the rates.RData stored in the package. The
#' usage of rates.RData is explained in the rates.Rd help file. Please
#' type ?rates to see it.
#'
#' @param start is the start date of the data frame; it is the earliest day
#'        of interest rate that we want in the data frame
#' @param end is the end date of the data frame; it is the lastest day
#'        of interest rate that we want in the data frame
#' 
#' @return a data frame that contains the rates based on the ISDA 
#'         pecifications
#'
#' @export
#' 
#' @examples
#' \dontrun{
#' build.rates(start = as.Date("2004-01-01"), end = as.Date("2014-08-23"))
#' }

build.rates <- function(start = as.Date("2004-01-01"), 
                        end = as.Date("2005-01-04")){
  
  x.markit.USD <- download.markit(start = start, end = end, currency = "USD")
  x.markit.EUR <- download.markit(start = as.Date("2005-01-05"), 
                                  end = end, currency = "EUR")
  x.markit.JPY <- download.markit(start = as.Date("2005-01-05"), 
                                  end = end, currency = "JPY")
  
  x.FRED.EUR   <- download.FRED(start = start, end = as.Date("2005-01-04"), 
                              currency = "EUR")
  x.FRED.JPY   <- download.FRED(start = start, end = as.Date("2005-01-04"), 
                              currency = "JPY")
  
  x <- rbind(x.markit.USD, x.FRED.EUR, 
             x.markit.EUR, x.FRED.JPY, x.markit.JPY)
  
  x <- x[order((x$date), decreasing = TRUE), ]
}