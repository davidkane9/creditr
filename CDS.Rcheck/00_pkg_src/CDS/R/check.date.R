#' \code{check.date} for testing if the date entered is valid. This
#' function is used in CDS.R, CS10, get.rates.DF, IR.DV01, rec.risk
#' spread.DV.01, and upfront.
#
#' @param date entered
#' @return TRUE if date is valid, FALSE if date is in future, and 
#' "Invalid date format. Must be YYYY-MM-DD" if format is wrong

check.date <- function(date){

  ## This function is used in CDS.R, CS10, get.rates.DF, IR.DV01, 
  ## rec.risk spread.DV.01, and upfront. So we still need it.
  
  ## try to convert date to class date. Return false if it is not in the correct format
  
  date <- tryCatch(as.Date(date, format = "%Y-%m-%d"),
                   error = function(e) {
                       return(FALSE)
                   })
  today <- Sys.Date()
  
  ## if trade date is NA
  
  if (is.na(date)){
      return(FALSE)
  } 
  
  ## Trade date should not be in the future
  
  else if (date > today){
      return(FALSE)
  } 
  
  ## Trade date too early i.e before 1994
  
  else if (as.numeric(format(date, "%Y")) < 1994){
      return(FALSE)
  } 
  
  else {
      return(TRUE)
  }
} 
