#' Update with New CDS
#' 
#' \code{update} spread or ptsUpfront or upfront based on a new CDS class object.
#'
#' @param object is a \code{CDS} class object.
#' @param spread is the new spread in bps.
#' @param isPriceClean specifies whether it is a dirty or clean upfront.
#' 
#' @return a \code{CDS} class object
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ## build a CDS class object
#' cds1 <- CDS(date = as.Date("2014-05-07"), tenor = 5, spread = 50, coupon = 100)
#'
#' ## update
#' update(cds1, spread = 55)
#' }

setMethod("update",
          signature(object = "CDS"),
          function(object,
                   isPriceClean = FALSE,
                   spread = NULL,
                   ...){
            
                  ## must provide new spread for an update

                  stopifnot (!is.null(spread))

                  newCDS <- CDS(contract = object@contract,
                                name = object@name,
                                RED = object@RED,
                                date = object@date,
                                currency = object@currency,
                                maturity = object@maturity,
                                tenor = object@tenor,                               
                                spread = spread,
                                coupon = object@coupon,
                                recovery = object@recovery,
                                notional = object@notional)
                  return(newCDS)
          }
          )
