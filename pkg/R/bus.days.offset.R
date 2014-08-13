#' \code{bus.days.offset} passes R objects to compiled C code loaded into R to adjust for business days.
#'
#' @param fromDate starting date
#' @param offset function.
#' @param holidays holidays is an input for holiday files to adjust to
#' business day counting. Default is \code{None}.

bus.days.offset <- function(fromDate, offset, holidays = NULL){
    fromDate <- .separate.YMD(fromDate)
    
    .Call('busDaysOffset',
          fromDate_input = fromDate,
          offset_input = offset,
          holidays = holidays,
          PACKAGE = 'CDS')
}
