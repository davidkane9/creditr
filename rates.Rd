\name{rates}
\alias{rates}
\docType{data}
\title{
Interest Rates Dataset
}
\description{
Historic Interest Rates
}
\usage{data(rates)}
\format{
  A data frame with 551 observations on the following 4 variables.
  \describe{
    \item{\code{date}}{a Date}
    \item{\code{currency}}{a factor with levels \code{USD}}
    \item{\code{expiry}}{a factor with levels \code{10Y} \code{12Y} \code{15Y} \code{1M} \code{1Y} \code{20Y} \code{25Y} \code{2M} \code{2Y} \code{30Y} \code{3M} \code{3Y} \code{4Y} \code{5Y} \code{6M} \code{6Y} \code{7Y} \code{8Y} \code{9Y}}
    \item{\code{rates}}{a numeric vector}
  }
}
\details{
Dataframe for a given currency with columns - expiry, date and rates.
}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
Writing R Extensions
}
\examples{
data(rates)
## maybe str(rates) ; plot(rates) ...
}
\keyword{datasets}
