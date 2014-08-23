#' Calcualte Default Probability with Spread
#' 
#' \code{spread.to.pd} approximates the default probability at time given the spread
#'
#' @param spread in bps
#' @param time in years
#' @param recovery.rate in decimal. Default is 0.4.
#' @return default probability in decimals

spread.to.pd <- function(spread, time, recovery.rate = 0.4){
    
    ## Bloomberg Approximation
    
    return(1 - exp(-spread/1e4*time/(1 - recovery.rate)))
}


