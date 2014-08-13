## rec.risk.01.test.R

library(CDS)

## comparing rec.risk.01 calculated by our package for Xerox Corp and Electrolux
## AB on April 22, 2014 with the results on Bloomberg

x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
                currency = c("USD", "EUR"),
                tenor = c("5Y", "5Y"),
                maturity = c(NA, NA),
                spread = c(105.8, 99),
                coupon = c(100, 100),
                recoveryRate = c(0.4, 0.4),
                notional = c(1e7, 1e7))

result <- rec.risk.01(x)

truth <- c(-20.85, 3.46)

x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-15")),
                currency = c("USD", "JPY"),
                tenor = c("5Y", "5Y"),
                maturity = c(NA, NA),
                spread = c(105.8, 250),
                coupon = c(100, 100),
                recoveryRate = c(0.4, 0.35),
                notional = c(1e7, 1e7))

## stopifnot(all.equal(round(result), round(truth)))

rates <- get.rates(as.Date("2014-04-22"), currency = "EUR")[[1]]

upfront(data.frame(date = as.Date("2014-04-22"),
        currency = "EUR",
        tenor = "5Y",
        spread = 99,
        coupon = 100,
        recovery = 0.41), rates = rates)


