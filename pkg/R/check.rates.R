#' \code{check.date} for testing whether the trade date is valid
#
#' @param date date entered
#' @return TRUE if date is valid, FALSE if date is in future, and 
#' "Invalid date format. Must be YYYY-MM-DD" if format is wrong

check.date <- function(date){
  
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
