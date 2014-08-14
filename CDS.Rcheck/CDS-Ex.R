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
cds <- CDS(TDate = as.Date("2014-05-07"), tenor = 5, parSpread = 50, coupon = 100)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("CDS", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("CS10")
### * CS10

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: CS10
### Title: 'CS10' Calculates the change in upfront value when the parSpread
###   rises by 10 also known as the CS10 of a contract.
### Aliases: CS10

### ** Examples

x <- data.frame(dates = c(as.Date("2014-04-22"), as.Date("2014-04-22")),
currency = c("USD", "EUR"),
maturity = c(NA, NA),
tenor = c(5, 5),
spread = c(120, 110),
coupon = c(100, 100),
recoveryRate = c(0.4, 0.4),
notional = c(1e7, 1e7))
result <- CS10(x)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("CS10", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
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
nameEx("get.date")
### * get.date

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get.date
### Title: 'get.date' returns appropriate dates used in pricing a CDS
###   contract.
### Aliases: get.date

### ** Examples

get.date(as.Date("2014-05-07"), tenor = 5, maturity = NULL)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("get.date", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("get.rates")
### * get.rates

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get.rates
### Title: 'get.rates' returns the deposits and swap rates for the day
###   input, along with the date conventions for that specific currency.
###   The day input should be a weekday. If not, go to the most recent
###   previous weekday.
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
### Keywords: datasets

### ** Examples

data(rates)
## for JPY rates: 
## rates[rates$currency=="JPY",]
## for USD rates (similarly "USD" can be replace with "EUR" or "GBP"):
## rates[rates$currency=="USD",]
## for rates on a specific date, of a specific currency:
## rates[rates$currency=="JPY" & rates$date=="2005-10-01",]



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("rates", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("update-CDS-method")
### * update-CDS-method

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: update,CDS-method
### Title: 'update' spread or ptsUpfront or upfront based on a new CDS
###   class object.
### Aliases: update,CDS-method

### ** Examples

## build a CDS class object
cds1 <- CDS(TDate = as.Date("2014-05-07"), tenor = 5, parSpread = 50, coupon = 100)

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
