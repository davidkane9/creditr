## IR.DV.01.R

library(CDS)

## comparing IR.DV.01 calculated by our package for Xerox Corp and Electrolux
## AB on April 22, 2014 with the results on Bloomberg

x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
                currency = c("USD", "EUR"),
                tenor = c("5Y", "5Y"),
                maturity = c(NA, NA),
                spread = c(105.8, 99),
                coupon = c(100, 100),
                recoveryRate = c(0.4, 0.4),
                notional = c(1e7, 1e7))

result <- IR.DV.01(x)

truth <- c(-7.36, 1.29)

## stopifnot(all.equal(round(result), round(truth)))

