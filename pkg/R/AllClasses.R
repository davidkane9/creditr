#' CDS Class
#' 
#' Class definition for the \code{CDS-Class}
#'
#' @slot name is the name of the reference entity. Optional.
#' @slot contract is the contract type, default SNAC
#' @slot RED alphanumeric code assigned to the reference entity. Optional.
#' 
#' @slot date is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}.
#' @slot spread CDS par spread in bps.
#' @slot maturity date of the CDS contract.
#' @slot tenor of contract in number of years - 5, 3
#' @slot coupon quoted in bps. It specifies the payment amount from
#' @slot recovery.rate in decimal. Default is 0.4.
#' @slot currency in which CDS is denominated.
#' @slot principal is the dirty \code{upfront} less the \code{accrual}.
#' @slot accrual is the accrued interest payment.
#' @slot defaultProb is the approximate the default probability at
#' time t given the \code{spread}.
#' @slot defaultExpo calculates the default exposure of a CDS contract
#' based on the formula: Default Exposure: (1-Recovery Rate)*Notional
#' - Principal.
#' @slot price
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
#' 
#' @name CDS, CDS-class
#' @aliases CDS, CDS-class
#' @docType class
#' @rdname CDS-class
#' @export
#' 

setClass("CDS",
         representation = representation(
           
           ## name stuff
           
           name = "character",
           contract = "character",
           RED = "character",
          
           ## basic info
           
           date = "Date",
           spread = "numeric",
           maturity = "Date",
           tenor = "numeric",
           coupon = "numeric",
           recovery.rate = "numeric",
           currency = "character",
           notional = "numeric",
           principal = "numeric",
           accrual = "numeric",
           defaultProb = "numeric",
           defaultExpo = "numeric",
           price = "numeric",
           
           ## calculated amount
           
           upfront = "numeric",
           ptsUpfront = "numeric",
           spreadDV01 = "numeric",
           IRDV01 = "numeric",
           RecRisk01 = "numeric"  
         ),
         prototype = prototype(
          
           ## name stuff
           
           name = character(),
           contract = character(),
           RED = character(),
           
           ## basic info
           
           date = character(),
           spread = numeric(),
           maturity = character(),
           tenor = numeric(),
           coupon = numeric(),
           recovery.rate = numeric(),
           currency = character(),
           notional = numeric(),
           principal = numeric(),
           accrual = numeric(),
           defaultProb = numeric(),
           defaultExpo = numeric(),
           price = numeric(),
           
           ## calculated amount
           
           upfront = numeric(),
           ptsUpfront = numeric(),
           spreadDV01 = numeric(),
           IRDV01 = numeric(),
           RecRisk01 = numeric()
         )
)