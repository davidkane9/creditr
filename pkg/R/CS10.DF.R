#' function that takes a vector of CDS objects to return a vector of CS 10 calculations for each object
#' 
#' @param cds vector of CDS objects
#' @return vector of CS10 values

CS10.DF <- function(cds){
  return(sapply(cds, CS10))
}