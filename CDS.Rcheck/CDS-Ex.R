pkgname <- "CDS"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
base::assign(".ExTimings", "CDS-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('CDS')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("CDS")
### * CDS

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: CDS
### Title: Build a 'CDS' class object given the input about a CDS contract.
### Aliases: CDS

### ** Examples

# Build a simple CDS class object
require(CDS)
cds <- CDS(date = as.Date("2014-05-07"), tenor = 5, spread = 50, coupon = 100)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("CDS", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("CS10")
### * CS10

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: CS10
### Title: Calculate CS10
### Aliases: CS10

### ** Examples

x <- data.frame(date = as.Date(c("2014-04-22", "2014-04-22")),
                currency = c("USD", "EUR"),
                tenor = c(5, 5),
                spread = c(120, 110),
                coupon = c(100, 100),
                recovery.rate = c(0.4, 0.4),
                notional = c(1e7, 1e7))
result <- CS10(x)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("CS10", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("IR.DV01")
### * IR.DV01

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: IR.DV01
### Title: Calculate IR.DV01
### Aliases: IR.DV01

### ** Examples

x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
currency = c("USD", "EUR"),
tenor = c(5, 5),
spread = c(120, 110),
coupon = c(100, 100),
recovery.rate = c(0.4, 0.4),
notional = c(1e7, 1e7))
result <- IR.DV01(x)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("IR.DV01", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("JPY.holidays")
### * JPY.holidays

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: JPY.holidays
### Title: Japanese Holidays
### Aliases: JPY.holidays
### Keywords: datasets

### ** Examples

data(JPY.holidays)
## maybe str(JPY.holidays) ; plot(JPY.holidays) ...



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("JPY.holidays", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("add.conventions")
### * add.conventions

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: add.conventions
### Title: Return accounting conventions
### Aliases: add.conventions

### ** Examples

x1 <- data.frame(date = as.Date("2014-05-07"), currency = "USD")
add.conventions(x1)

x2 <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")), currency = c("USD", "JPY"))
add.conventions(x2)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("add.conventions", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("add.dates")
### * add.dates

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: add.dates
### Title: Return CDS dates
### Aliases: add.dates

### ** Examples

x1 <- data.frame(date = as.Date("2014-05-07"), tenor = 5, currency = "USD")
add.dates(x1)

x2 <- data.frame(date = c(as.Date("2014-05-06"), as.Date("2014-05-07")),
tenor = rep(5, 2),
currency = "JPY")
add.dates(x2)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("add.dates", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("get.rates")
### * get.rates

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get.rates
### Title: Get Rates
### Aliases: get.rates

### ** Examples

get.rates(as.Date("2014-05-07"), currency = "USD")



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("get.rates", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("rates")
### * rates

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: rates
### Title: Historic Interest Rates
### Aliases: rates rates.this upfront.data
### Keywords: datasets, interest rates

### ** Examples

data(rates)

## for JPY rates: 
 rates[rates$currency == "JPY",]

## for rates on a specific date, of a specific currency:
rates[rates$currency == "USD" & rates$date == "2005-10-01",]



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("rates", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("rec.risk.01")
### * rec.risk.01

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: rec.risk.01
### Title: Calculate RR change
### Aliases: rec.risk.01

### ** Examples

x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
currency = c("USD", "EUR"),
tenor = c(5, 5),
spread = c(120, 110),
coupon = c(100, 100),
recovery.rate = c(0.4, 0.4),
notional = c(1e7, 1e7))
result <- rec.risk.01(x)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("rec.risk.01", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("spread.DV01")
### * spread.DV01

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: spread.DV01
### Title: Calculate Spread Change
### Aliases: spread.DV01

### ** Examples

x <- data.frame(date = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
currency = c("USD", "EUR"),
tenor = c(5, 5),
spread = c(120, 110),
coupon = c(100, 100),
recovery.rate = c(0.4, 0.4),
notional = c(1e7, 1e7))
spread.DV01(x)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("spread.DV01", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("update-CDS-method")
### * update-CDS-method

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: update,CDS-method
### Title: Update with New CDS
### Aliases: update,CDS-method

### ** Examples

## build a CDS class object
cds1 <- CDS(date = as.Date("2014-05-07"), tenor = 5, spread = 50, coupon = 100)

## update
update(cds1, spread = 55)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("update-CDS-method", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
