#' CDS Class
#' 
#' Class definition for the \code{CDS-Class}
#'
#' @slot contract is the contract type, default SNAC
#' @slot name is the name of the reference entity. Optional.
#' @slot RED alphanumeric code assigned to the reference entity. Optional.
#' @slot date is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}.
#' @slot baseDate is the start date for the IR curve. Default is date. 
#' @slot currency in which CDS is denominated. 
#' @slot interest.rates a list which contains types, rates and expiries
#' @slot dates named array which contains relevant date data
#' @slot maturity date of the CDS contract.
#' @slot tenor of contract in number of years - 5, 3
#' @slot spread CDS par spread in bps.
#' @slot coupon quoted in bps. It specifies the payment amount from
#' the protection buyer to the seller on a regular basis.
#' @slot recovery.rate in decimal. Default is 0.4.
#' @slot inputPriceClean records the \code{isPriceClean} argument
#' input by the user. \code{isPriceClean} refers to the type of
#' upfront calculated. It is boolean. When \code{TRUE}, calculate
#' principal only. When \code{FALSE}, calculate principal + accrual.
#' @slot notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' @slot payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' @slot principal is the dirty \code{upfront} less the \code{accrual}.
#' @slot accrual is the accrued interest payment.
#' @slot upfront is quoted in the currency amount. Since a standard
#' contract is traded with fixed coupons, upfront payment is
#' introduced to reconcile the difference in contract value due to the
#' difference between the fixed coupon and the conventional par
#' spread. There are two types of upfront, dirty and clean. Dirty
#' upfront, a.k.a. Cash Settlement Amount, refers to the market value
#' of a CDS contract. Clean upfront is dirty upfront less any accrued
#' interest payment, and is also called the Principal.
#' @slot ptsUpfront is quoted as a percentage of the notional
#' amount. They represent the upfront payment excluding the accrual
#' payment. High Yield (HY) CDS contracts are often quoted in points
#' upfront. The protection buyer pays the upfront payment if points
#' upfront are positive, and the buyer is paid by the seller if the
#' points are negative.
#' @slot spreadDV01 measures the sensitivity of a CDS contract
#' mark-to-market to a parallel shift in the term structure of the par
#' spread.
#' @slot IRDV01 is the change in value of a CDS contract for a 1 bp
#' parallel increase in the interest rate curve. \code{IRDV01} is,
#' typically, a much smaller dollar value than \code{spreadDV01}
#' because moves in overall interest rates have a much smaller effect
#' on the value of a CDS contract than does a move in the CDS spread
#' itself.
#' @slot RecRisk01 is the dollar value change in market value if the
#' recovery rate used in the CDS valuation were increased by 1\%.
#' @slot defaultProb is the approximate the default probability at
#' time t given the \code{spread}.
#' @slot defaultExpo calculates the default exposure of a CDS contract
#' based on the formula: Default Exposure: (1-Recovery Rate)*Notional
#' - Principal.
#' @slot conventions a named vector which contains all the 12 conventional
#' parameters: mmDCC, calendar, fixedSwapDCC, floatSwapDCC, fixedSwapFreq,
#' floatSwapFreq, holidays, dccCDS, badDayConvCDS,
#' and badDayConvZC with their default values
#' @name CDS, CDS-class
#' @aliases CDS, CDS-class
#' @docType class
#' @rdname CDS-class
#' @export
#' 

setClass("CDS",
         representation = representation(
           contract = "character",
           name = "character",
           RED = "character",
           date = "Date",
           baseDate = "Date",
           currency = "character",
           
           interest.rates = "list",
           
           dates = "data.frame",
           
           maturity = "Date",
           tenor = "numeric",
           
           spread = "numeric",
           coupon = "numeric",
           recovery.rate = "numeric",
           inputPriceClean = "logical",
           notional = "numeric",
           payAccruedOnDefault = "logical",
           
           principal = "numeric",
           accrual = "numeric",
           upfront = "numeric",
           ptsUpfront = "numeric",
           spreadDV01 = "numeric",
           IRDV01 = "numeric",
           RecRisk01 = "numeric",
           defaultProb = "numeric",
           defaultExpo = "numeric",
           price = "numeric",
           conventions = "data.frame"
         ),
         prototype = prototype(
           contract = character(),
           name = character(),
           RED = character(),
           date = character(),
           baseDate = character(),
           currency = character(),
           
           interest.rates = list(),
      
           
           dates = data.frame(),
           
           maturity = character(),
           tenor = numeric(),
           
          
           spread = numeric(),
           coupon = numeric(),
           recovery.rate = numeric(),
           inputPriceClean = logical(),
           notional = numeric(),
           payAccruedOnDefault = logical(),
           principal = numeric(),
           accrual = numeric(),
           upfront = numeric(),
           ptsUpfront = numeric(),
           spreadDV01 = numeric(),
           IRDV01 = numeric(),
           RecRisk01 = numeric(),
           defaultProb = numeric(),
           defaultExpo = numeric(),
           price = numeric(),
           conventions = data.frame()
         )
)