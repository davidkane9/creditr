#' \code{update} spread or ptsUpfront or upfront based on a new CDS class object.
#'
#' @param object is a \code{CDS} class object.
#' @param upfront is the new upfront payment amount.
#' @param ptsUpfront is the new pts upfront. It's in decimal.
#' @param spread is the new spread in bps.
#' @param isPriceClean specifies whether it is a dirty or clean
#' upfront.
#' @return a \code{CDS} class object
#'
#' @export
#'
#' @examples
#'
#' ## build a CDS class object
#' cds1 <- CDS(TDate = "2014-05-07", tenor = 5, parSpread = 50, coupon = 100)
#'
#' ## update
#' update(cds1, spread = 55)

setMethod("update",
          signature(object = "CDS"),
          function(object,
                   upfront = NULL,
                   isPriceClean = FALSE,
                   ptsUpfront = NULL,
                   spread = NULL,
                   ...){

              if ((as.numeric(!is.null(upfront)) + 
                   as.numeric(!is.null(ptsUpfront)) + 
                   as.numeric(!is.null(spread))) > 1)
                  stop ("Please only update one option -- upfront, ptsUpfront or spread")
              
              if (!is.null(upfront)){
                  newSpread <- NULL
                  newUpfront <- upfront
                  newPtsUpfront <- NULL
              } else if (!is.null(ptsUpfront)){
                  newSpread <- NULL
                  newUpfront <- NULL
                  newPtsUpfront <- ptsUpfront
              } else if (!is.null(spread)){
                  newSpread <- spread
                  newUpfront <- NULL
                  newPtsUpfront <- NULL
              }
                  newCDS <- CDS(contract = object@contract,
                                entityName = object@entityName,
                                RED = object@RED,
                                TDate = object@TDate,
                                baseDate = object@baseDate,
                                currency = object@currency,
                                types = object@types,
                                rates = object@rates,
                                expiries = object@expiries,
                                mmDCC = object@mmDCC, 
                                fixedSwapFreq = object@fixedSwapFreq,
                                floatSwapFreq = object@floatSwapFreq,
                                fixedSwapDCC = object@fixedSwapDCC,
                                floatSwapDCC = object@floatSwapDCC,
                                badDayConvZC = object@badDayConvZC,
                                holidays = object@holidays,
                                valueDate = object@valueDate,
                                benchmarkDate = object@benchmarkDate,
                                startDate = object@startDate,
                                endDate = object@endDate,
                                stepinDate = object@stepinDate,
                                maturity = object@maturity,
                                tenor = object@tenor,                               
                                dccCDS = object@dccCDS,
                                freqCDS = object@freqCDS,
                                stubCDS = object@stubCDS,
                                badDayConvCDS = object@badDayConvCDS,
                                calendar = object@calendar,
                                parSpread = newSpread,
                                coupon = object@coupon,
                                recoveryRate = object@recoveryRate,
                                upfront = newUpfront,
                                ptsUpfront = newPtsUpfront, 
                                isPriceClean = isPriceClean,
                                notional = object@notional,
                                payAccruedOnDefault = object@payAccruedOnDefault)
                  
                  return(newCDS)

          }
          )
