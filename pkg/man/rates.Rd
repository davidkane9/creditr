\name{rates}
\alias{rates}
\docType{data}
\title{
Historic Interest Rates
}
\description{
Interest rates for USD, EUR, GBP, and JPY from 2003-01-02 till 2014-07-16.
}
\usage{data(rates)}
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
%%  ~~ If necessary, more details than the __description__ above ~~
}
\source{
\url{https://www.markit.com/}
}
\references{
%%  ~~ possibly secondary sources and usages ~~
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
