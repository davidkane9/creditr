\name{getRates}
\alias{getRates}
\title{The function returns the deposits and swap rates for the day
input. The day input should be a weekday. If not, go to the most
recent previous weekday.}
\usage{
getRates(date = Sys.Date(), currency = "USD")
}
\arguments{
  \item{date}{ideally a weekday. The rates for a trade date
  T are published on T-1 weekday.This date refers to the
  day on which we want the CDS to be priced, not the date
  for the interest rates as the interest rates will be used
  is the day before the trade date. Eg. If we are trying to
  find the rates used to price a CDS on 2014-04-22, it will
  return the rates of 2014-04-21}

  \item{currency}{the three-letter currency code. As of
  now, it works for USD, EUR, and JPY. The default is USD.}
}
\value{
a list with two data frames. The first data frame contains
the rates based on the ISDA specifications; the second
contains all the dcc and calendar specifications of the
curve.
}
\description{
Assume date and currency are in the same location.
}
\examples{
getRates(as.Date("2014-05-07"), currency = "USD")
}

