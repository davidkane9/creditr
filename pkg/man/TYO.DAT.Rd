\name{TYO.DAT}
\alias{TYO.DAT}
\docType{data}
\title{
Japanese Holidays
}
\description{
Dates of Japanese holidays that will be used in the pricing of CDSs denominated in the Japanese Yen.
}
\usage{data(TYO.DAT)}
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
https://www.markit.com/news/TYO.DAT
}
\examples{
data(TYO.DAT)
## maybe str(TYO.DAT) ; plot(TYO.DAT) ...
}
\keyword{datasets}
