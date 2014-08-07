\name{JPY.holidays}
\alias{JPY.holidays}
\docType{data}
\title{
Japanese Holidays
}
\description{
Dates of Japanese holidays that will be used in the pricing of CDSs denominated in the Japanese Yen.
}
\usage{data(JPY.holidays)}
\format{
  A data frame with 53 observations on the following variable.
  \describe{
    \item{\code{X20090320}}{a numeric vector}
  }
}
\details{
These dates are necessary in determining the interest rate curves. If the trade date (T) lies on the day
before a holiday we won't use the curve on T-1, but the last business day, which in this case will be T-2 (assuming T-2 is also a weekday).
}
\source{
https://www.markit.com/news/JPY.holidays
}
\examples{
data(JPY.holidays)
## maybe str(JPY.holidays) ; plot(JPY.holidays) ...
}
\keyword{datasets}
