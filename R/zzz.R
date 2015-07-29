.onLoad <- function(libname, pkgname) {
  if(!require(creditrISDA)){
    devtools::install_github("knightsay/creditrISDA")
  }
  require(creditrISDA)
}