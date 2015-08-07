#' The creditrISDA package.
#'
#' \code{creditrISDA} package contains the C code of ISDA Standard Model, which is developed
#' for evaluating credit default swaps (CDS). After Big Bang Protocol came out in 2009 
#' after the financial crysis, CDS trading is standardized and ISDA Standard Model
#' becomes a widely used approach to price CDS and measure risk exposures of CDS. 
#'
#' \code{creditrISDA} package contains the C code of the original open-source ISDA Model,
#' as well as the R wrapper to call ISDA Model with R functions, using \code{Rcpp}. This
#' package is intended to be a helper package for R package \code{creditr}, which is 
#' available on CRAN.
#' 
#' @name creditrISDA
#' @docType package
#' 
#' @import Rcpp
#' @import xts
#' @import zoo
#' @import quantmod
#' 
#' @useDynLib creditrISDA
#' @exportPattern "^[[:alpha:]]+"
NULL