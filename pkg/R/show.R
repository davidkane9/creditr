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
                                    40-.check.length("Contract Type:") -
                                    .check.length(object@contract)), collapse = ""))),
                  sprintf(paste("   Currency:", object@currency,
                                sep = paste0(rep(" ",
                                    40-.check.length("   Currency:") -
                                    .check.length(object@currency)),
                                    collapse = ""))), "\n",

                  sprintf(paste("Entity Name:", object@entityName,
                                sep = paste0(rep(" ",
                                    40-.check.length("Entity Name:") -
                                    .check.length(object@entityName)), collapse = ""))),
                  sprintf(paste("   RED:", object@RED,
                                sep = paste0(rep(" ",
                                    40-.check.length("   RED:") -
                                    .check.length(object@RED)),
                                    collapse = ""))), "\n",

                  sprintf(paste("TDate:", object@TDate,
                                sep = paste0(rep(" ", 40-.check.length("TDate:") -
                                    .check.length(object@TDate)), collapse = ""))),
                  sprintf(paste("   End Date:", object@endDate,
                                sep = paste0(rep(" ", 40-.check.length("   End Date:") -
                                    .check.length(object@endDate)),
                                    collapse = ""))), "\n",

                  sprintf(paste("Start Date:", object@startDate,
                                sep = paste0(rep(" ", 40-.check.length("Start Date:") -
                                    .check.length(object@startDate)), collapse = ""))),
                  sprintf(paste("   Backstop Date:", object@backstopDate,
                                sep = paste0(rep(" ", 40-
                                    .check.length("   Backstop Date:") -
                                    .check.length(object@backstopDate)),
                                    collapse = ""))), "\n",

                  sprintf(paste("1st Coupon:", object@firstcouponDate,
                                sep = paste0(rep(" ", 40-.check.length("1st Coupon:") -
                                    .check.length(object@firstcouponDate)),
                                    collapse = ""))),
                  sprintf(paste("   Pen Coupon:", object@pencouponDate,
                                sep = paste0(rep(" ", 40-
                                    .check.length("   Pen Coupon:") -
                                    .check.length(object@pencouponDate)),
                                    collapse = ""))), "\n",

                  sprintf(paste("Day Cnt:", object@convention['dccCDS'],
                                sep = paste0(rep(" ",
                                    40-.check.length("Day Cnt:") -
                                    .check.length(object@convention['dccCDS'])), collapse = ""))),
                  sprintf(paste("   Freq:", object@convention['freqCDS'],
                                sep = paste0(rep(" ", 40-.check.length("   Freq:") -
                                    .check.length(object@convention['freqCDS'])),
                                    collapse = ""))), "\n",
                  sep = ""
                  )

              cat("\n")
              cat("Calculation \n")
              
              cat(sprintf(paste("Value Date:", object@valueDate,
                                sep = paste0(rep(" ",
                                    40-.check.length("Value Date:") -
                                    .check.length(object@valueDate)),
                                    collapse = ""))),
                  sprintf(paste("   Price:",
                                format(round(object@price, 2), big.mark=",",
                                       scientific = F),
                                sep = paste0(rep(" ", 40-.check.length("   Price:") -
                                    .check.length(
                                        format(round(object@price, 2), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",
                  
                  sprintf(paste("Spread:",
                                format(round(object@parSpread, 4), big.mark = ",",
                                       scientific = F),
                                sep = paste0(rep(" ",
                                    40-.check.length("Spread:") -
                                    .check.length(format(round(object@parSpread, 4), big.mark = ",",
                                                        scientific = F))),
                                    collapse = ""))),
                  sprintf(paste("   Pts Upfront:",
                                format(round(object@ptsUpfront, 4), big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.check.length("   Pts Upfront:") -
                                    .check.length(
                                        format(round(object@ptsUpfront, 4), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",

                  sprintf(paste("Principal:",
                                format(round(object@principal, 0), big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ",
                                    40-.check.length("Principal:") -
                                    .check.length(
                                        format(round(object@principal, 0), big.mark = "F", scientific = F))),
                                    collapse = ""))),
                  sprintf(paste("   Spread DV01:",
                                format(round(object@spreadDV01, 0), big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.check.length("   Spread DV01:") -
                                    .check.length(
                                        format(round(object@spreadDV01, 0), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",
                  
                  sprintf(paste("Accrual:",
                                format(round(object@accrual, 0), big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ",
                                    40-.check.length("Accrual:") -
                                    .check.length(
                                        format(round(object@accrual, 0), big.mark = ",",
                                               scientific=F))),
                                    collapse = ""))), 
                  sprintf(paste("   IR DV01:", format(round(object@IRDV01, 2),big.mark=",",
                                                      scientific=F),
                                sep = paste0(rep(" ",
                                    40-.check.length("   IR DV01:") -
                                    .check.length(
                                        format(round(object@IRDV01, 2), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",

                  sprintf(paste("Upfront:",
                                format(round(object@upfront, 0), big.mark = ",",
                                       scientific=F),
                                sep = paste0(rep(" ",
                                    40-.check.length("Upfront:") -
                                    .check.length(
                                        format(round(object@upfront, 0), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), 
                  sprintf(paste("   Rec Risk (1 pct):",
                                format(round(object@RecRisk01, 2),big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.check.length("   Rec Risk (1 pct):") -
                                    .check.length(
                                        format(round(object@RecRisk01, 2),
                                               big.mark=",", scientific=F))),
                                    collapse = ""))), "\n",

                  sprintf(paste("Default Prob:", round(object@defaultProb, 4),
                                sep = paste0(rep(" ",
                                    40-.check.length("Default Prob:") -
                                    .check.length(round(object@defaultProb, 4))),
                                    collapse = ""))), 
                  sprintf(paste("   Default Expo:",
                                format(round(object@defaultExpo, 0),big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.check.length("   Default Expo:") -
                                    .check.length(
                                        format(round(object@defaultExpo, 0),
                                               big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",

                  sep = ""
                  )
              cat("\n")
              cat(paste0("Credit curve effective of ",
                         object@effectiveDate), "\n")

              ratesDf <- data.frame(Term = object@expiries, Rate = object@rates)
              rowN <- ceiling(dim(ratesDf)[1]/2)
              print(as.data.frame(.cbind.fill(ratesDf[1:rowN,],
                                              ratesDf[(rowN+1):dim(ratesDf)[1],])),
                    row.names = F, quote = F, na.print = "")
              
              cat("\n")
          
      }
)

