#' \code{CS10} Calculates the change in upfront value when the parSpread rises by 10%, 
#' also known as the CS10 of a contract.
#'
#' Calculate the change in value of the contract when there is a 10%
#' on the spread of the contract.
#' 
#' @param object is a \code{CDS} class object.
#' @return a numeric indicating the CS10 of the contract.
#' @examples
#' # construct a CDS class object
#' cds1 <- CDS(TDate = "2014-05-07", tenor="5Y", parSpread = 50, coupon = 100)
#'
#' # use CS10
#' CS10(cds1)
#' 
#' @export

CS10 <- function(object){
    
    new <- upfront(TDate = object@TDate,
                  parSpread = object@parSpread * 1.1,
                  recoveryRate = object@recoveryRate,
                  notional = object@notional,
                  maturity = object@maturity,
                  coupon = object@object,
                  currency = object@currency)
    
    return(new - object@upfront)

}

#' The CS10 method for CDS class
#' 
#' @name CS10-method
#' @title S4 method CS10 
#' @aliases CS10,CDS-method
#' @docType methods
#' @rdname CS10-methods
#' @param object the input CDS class object
#' @export

setMethod("CS10",
          signature(object = "CDS"),
          function(object){
              
              new <- upfront(TDate = object@TDate,
                            parSpread = object@parSpread * 1.1,
                            recoveryRate = object@recoveryRate,
                            maturity = object@endDate,
                            notional = object@notional,
                            coupon = object@coupon,
                            currency = object@currency)
              
              return(new - object@upfront)
                            
          }
          )
