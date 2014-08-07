#' \code{bus.days.offset} passes R objects to compiled C code loaded into R to adjust for business days.
#'
#' @param fromDate starting date
#' @param offset function
#' @param holidays holidays is an input for holiday files to adjust to
#' business day counting. Default is \code{None}.

bus.days.offset <- function(fromDate, offset, holidays = NULL){
    fromDate <- .separateYMD(fromDate)
    
    .Call('busDaysOffset',
          fromDate,
          offset,
          holidays,
          PACKAGE = 'CDS')
}
