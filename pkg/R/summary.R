#' The summary method displays only the essential info about the CDS
#' class object.
#' 

setMethod("summary",
          signature(object = "CDS"),
          function(object,
                   ...){

              cat(sprintf(paste("Contract Type:", object@contract,
                                sep = paste0(rep(" ",
                                    40-.check.length("Contract Type:") -
                                    .check.length(object@contract)), collapse = ""))),
                  sprintf(paste("   TDate:", object@TDate,
                                sep = paste0(rep(" ", 40-.check.length("   TDate:") -
                                    .check.length(object@TDate)), collapse = ""))), "\n",

                  
                  sprintf(paste("Entity Name:", object@entityName,
                                sep = paste0(rep(" ",
                                    40-.check.length("Entity Name:") -
                                    .check.length(object@entityName)), collapse = ""))),
                  sprintf(paste("   RED:", object@RED,
                                sep = paste0(rep(" ", 40-.check.length("   RED:") -
                                    .check.length(object@RED)), collapse = ""))), "\n",
                  
                  sprintf(paste("Currency:", object@currency,
                                sep = paste0(rep(" ",
                                    40-.check.length("Currency:") -
                                    .check.length(object@currency)), collapse = ""))),
                  sprintf(paste("   End Date:", object@endDate,
                                sep = paste0(rep(" ", 40-.check.length("   End Date:") -
                                    .check.length(object@endDate)), collapse = ""))), "\n",
                  sprintf(paste("Spread:",
                                format(round(object@parSpread, 4),big.mark = ",",
                                       scientific=F),
                                sep = paste0(rep(" ",
                                    40-.check.length("Spread:") -
                                    .check.length(
                                        format(round(object@parSpread, 4), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))),
                  sprintf(paste("   Coupon:",
                                format(object@coupon, big.mark = ",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.check.length("   Coupon:") -
                                    .check.length(format(object@coupon, big.mark=",",
                                                        scientific=F))),
                                    collapse = ""))), "\n",
                  
                  sprintf(paste("Upfront:",
                                format(round(object@upfront, 0),big.mark=",",
                                       scientific =F ),
                                sep = paste0(rep(" ",
                                    40-.check.length("Upfront:") -
                                    .check.length(
                                        format(round(object@upfront, 0),
                                               big.mark=",", scientific=F))),
                                    collapse = ""))),
                  sprintf(paste("   Spread DV01:",
                                format(round(object@spreadDV01, 0), big.mark = ",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.check.length("   Spread DV01:") -
                                    .check.length(
                                        format(round(object@spreadDV01, 0), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",

                  sprintf(paste("IR DV01:",
                                format(round(object@IRDV01, 2),big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ",
                                    40-.check.length("IR DV01:") -
                                    .check.length(
                                        format(round(object@IRDV01, 2), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))),
                  sprintf(paste("   Rec Risk (1 pct):",
                                format(round(object@RecRisk01, 2),big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.check.length("   Rec Risk (1 pct):") -
                                    .check.length(
                                        format(round(object@RecRisk01, 2),
                                               big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",
                  sep = ""
                  )
              
              cat("\n")
          }
          )


