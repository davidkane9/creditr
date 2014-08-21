\name{rates}
\alias{rates}
\alias{rates.this}
\alias{upfront.data}
\docType{data}
\title{
Historic Interest Rates
}
\description{
Interest rates for USD, EUR, GBP, and JPY from 2003-01-02 till 2014-07-16. There are some missing data for either a currency or an expiry for a short period of time.
}
\usage{
data(rates)
}
\format{
  A data frame with 225067 observations on the following 4 variables.
  \describe{
    \item{\code{date}}{a Date}
    \item{\code{currency}}{a factor with levels \code{USD} \code{EUR} \code{GBP} \code{JPY}}
    \item{\code{expiry}}{a factor with levels \code{1M} \code{3Y} \code{1Y} \code{2M} \code{3M} \code{6M} \code{10Y} \code{12Y} \code{15Y} \code{20Y} \code{30Y} \code{4Y} \code{5Y} \code{6Y} \code{7Y} \code{8Y} \code{9M} \code{9Y} \code{2Y} \code{25Y}}
    \item{\code{rates}}{a numeric vector}
  }
}
\details{
\code{rates.Data} is created by a CDS function, \code{get.rates.DF}. Currently, the rates for all currencies (USD, JPY, EUR) date back to 2003-12-31. The source of these rates is from https://www.markit.com/ and . Also, please note that for different currencies, their conventional expiries are different. However, a currency's conventional expiry stays the same. Also, notice that the 
\code{rates} here does not correspond to the \code{date} in the data 
frame; they correspond to \code{trade date - 1}, given that the trade date is from Tuesday to Saturday; if the trade date is on Sunday or Monday, then the rates are the previous Friday's.
}
\source{
\url{https://www.markit.com/}
}
\examples{
data(rates)
## for JPY rates: 
## rates[rates$currency=="JPY",]
## for USD rates (similarly "USD" can be replace with "EUR" or "GBP"):
## rates[rates$currency=="USD",]
## for rates on a specific date, of a specific currency:
## rates[rates$currency=="JPY" & rates$date=="2005-10-01",]
}
\keyword{datasets}
\seealso{
 \code{\link{get.rates}}
 \code{\link{get.rates.DF}}
}
