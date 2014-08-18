#' Show method
#' 
#' \code{show} method for CDS class
#' 
#' @name show
#' @aliases show,CDS-method
#' @docType methods
#' @rdname show-methods
#' @param object the input \code{CDS} class object
#' @export


setMethod("show",
 signature(object = "CDS"),
 function(object){
   
   cat("CDS Contract \n")
   
   cat(sprintf(paste("Contract Type:", object@contract,
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Contract Type:")) -
                                        nchar(as.character(object@contract))), collapse = ""))),
       sprintf(paste("   Currency:", object@currency,
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("   Currency:")) -
                                        nchar(as.character(object@currency))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Entity Name:", object@entityName,
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Entity Name:")) -
                                        nchar(as.character(object@entityName))), collapse = ""))),
       sprintf(paste("   RED:", object@RED,
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("   RED:")) -
                                        nchar(as.character(object@RED))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("TDate:", object@TDate,
                     sep = paste0(rep(" ", 40-nchar(as.character("TDate:")) -
                                        nchar(as.character(object@TDate))), collapse = ""))),
       sprintf(paste("   End Date:", object@endDate,
                     sep = paste0(rep(" ", 40-nchar(as.character("   End Date:")) -
                                        nchar(as.character(object@endDate))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Start Date:", object@startDate,
                     sep = paste0(rep(" ", 40-nchar(as.character("Start Date:")) -
                                        nchar(as.character(object@startDate))), collapse = ""))),
       sprintf(paste("   Backstop Date:", object@backstopDate,
                     sep = paste0(rep(" ", 40-
                                        nchar(as.character("   Backstop Date:")) -
                                        nchar(as.character(object@backstopDate))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("1st Coupon:", object@firstcouponDate,
                     sep = paste0(rep(" ", 40-nchar(as.character("1st Coupon:")) -
                                        nchar(as.character(object@firstcouponDate))),
                                  collapse = ""))),
       sprintf(paste("   Pen Coupon:", object@pencouponDate,
                     sep = paste0(rep(" ", 40-
                                        nchar(as.character("   Pen Coupon:")) -
                                        nchar(as.character(object@pencouponDate))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Day Cnt:", object@convention['dccCDS'],
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Day Cnt:")) -
                     nchar(as.character(object@convention['dccCDS']))), collapse = ""))), "\n",
       sep = ""
   )
   
   cat("\n")
   cat("Calculation \n")
   
   cat(sprintf(paste("Value Date:", object@valueDate,
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Value Date:")) -
                                        nchar(as.character(object@valueDate))),
                                  collapse = ""))),
       sprintf(paste("   Price:",
                     format(round(object@price, 2), big.mark=",",
                            scientific = F),
                     sep = paste0(rep(" ", 40-nchar(as.character("   Price:")) -
                                        nchar(as.character(
                                          format(round(object@price, 2), big.mark=",",
                                                 scientific=F)))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Spread:",
                     format(round(object@parSpread, 4), big.mark = ",",
                            scientific = F),
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Spread:")) -
                     nchar(as.character(format(round(object@parSpread, 4), big.mark = ",",
                                                                  scientific = F)))),
                                  collapse = ""))),
       sprintf(paste("   Pts Upfront:",
                     format(round(object@ptsUpfront, 4), big.mark=",",
                            scientific=F),
                     sep = paste0(rep(" ", 40-nchar(as.character("   Pts Upfront:")) -
                                        nchar(as.character(
                                          format(round(object@ptsUpfront, 4), big.mark=",",
                                                 scientific=F)))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Principal:",
                     format(round(object@principal, 0), big.mark=",",
                            scientific=F),
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Principal:")) -
                                        nchar(as.character(
                           format(round(object@principal, 0), big.mark = "F", scientific = F)))),
                                  collapse = ""))),
       sprintf(paste("   Spread DV01:",
                     format(round(object@spreadDV01, 0), big.mark=",",
                            scientific=F),
                     sep = paste0(rep(" ", 40-nchar(as.character("   Spread DV01:")) -
                                        nchar(as.character(
                                          format(round(object@spreadDV01, 0), big.mark=",",
                                                 scientific=F)))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Accrual:",
                     format(round(object@accrual, 0), big.mark=",",
                            scientific=F),
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Accrual:")) -
                                        nchar(as.character(
                                          format(round(object@accrual, 0), big.mark = ",",
                                                 scientific=F)))),
                                  collapse = ""))), 
       sprintf(paste("   IR DV01:", format(round(object@IRDV01, 2),big.mark=",",
                                           scientific=F),
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("   IR DV01:")) -
                                        nchar(as.character(
                                          format(round(object@IRDV01, 2), big.mark=",",
                                                 scientific=F)))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Upfront:",
                     format(round(object@upfront, 0), big.mark = ",",
                            scientific=F),
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Upfront:")) -
                                        nchar(as.character(
                                          format(round(object@upfront, 0), big.mark=",",
                                                 scientific=F)))),
                                  collapse = ""))), 
       sprintf(paste("   Rec Risk (1 pct):",
                     format(round(object@RecRisk01, 2),big.mark=",",
                            scientific=F),
                     sep = paste0(rep(" ", 40-nchar(as.character("   Rec Risk (1 pct):")) -
                                        nchar(as.character(
                                          format(round(object@RecRisk01, 2),
                                                 big.mark=",", scientific=F)))),
                                  collapse = ""))), "\n",
       
       sprintf(paste("Default Prob:", round(object@defaultProb, 4),
                     sep = paste0(rep(" ",
                                      40-nchar(as.character("Default Prob:")) -
                                        nchar(as.character(round(object@defaultProb, 4)))),
                                  collapse = ""))), 
       sprintf(paste("   Default Expo:",
                     format(round(object@defaultExpo, 0),big.mark=",",
                            scientific=F),
                     sep = paste0(rep(" ", 40-nchar(as.character("   Default Expo:")) -
                                        nchar(as.character(
                                          format(round(object@defaultExpo, 0),
                                                 big.mark=",",
                                                 scientific=F)))),
                                  collapse = ""))), "\n",
       
       sep = ""
   )
   cat("\n")
   cat(paste0("Credit curve effective of ",
              object@effectiveDate), "\n")
   
   ratesDf <- data.frame(Term = object@expiries, Rate = object@rates)
   rowN <- ceiling(dim(ratesDf)[1]/2)
   
   nm <- list(ratesDf[1:rowN,],ratesDf[(rowN+1):dim(ratesDf)[1],]) 
   nm <- lapply(nm, as.matrix)
   n <- max(sapply(nm, nrow)) 
   result <- do.call(cbind, lapply(nm, function (x) rbind(x, matrix(, n-nrow(x), ncol(x))))) 
   
   print(as.data.frame(result),
         row.names = F, quote = F, na.print = "")
   
   cat("\n")
   
 }
)