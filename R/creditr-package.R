#' The creditr package.
#'
#' \code{creditr} package provides useful tools for pricing credit
#' default swaps (CDS). It enables CDS class object which has slots as
#' name, contract, RED, date, spread, maturity, teno, coupon, recovery,
#' currency, notional, principal, accrual, pd, price, upfront,
#' spread.DV01, IR.DV01 and rec.risk.01, with S4 methods like update,
#' show and summary. It also supports data frame input and is able to
#' provide convenient calculation of key CDS statistics through functions
#' like CS10, IR.DV01, rec.risk.01 and spread.DV01. Of other major
#' functions, spread.to.upfront and upfront.to.spread are designed to
#' compute one of spread and upfront given the other; spread.to.pd and
#' pd.to.spread, similarly, can calculate one of spread and probability
#' of default given the other; add.dates and add.conventions compute a
#' series of dates information and accounting conventions related to CDS
#' pricing. Finally, get.rates and build.rates facilitates direct
#' fetching of relevant interest rates from online sources. Thanks to 
#' ISDA Standard Model's Open Source license, we are able to create this
#' package for R users. You can find the Open Source licence of ISDA
#' Standard Model at "http://www.cdsmodel.com/cdsmodel/cds-disclaimer.html?"
#' 
#' @name creditr
#' @docType package
#' 
#' @useDynLib creditr
#' @exportPattern "^[[:alpha:]]+"
#'
#' @exportClass CDS
#' @exportMethod summary show
#' 
#' @import quantmod
#' @import devtools
#' @import methods
#' @import zoo
#' @import Rcpp
#' @import RCurl
#' @import XML
#' @import xts
NULL