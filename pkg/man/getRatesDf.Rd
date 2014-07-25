\name{getRatesDf}
\alias{getRatesDf}
\title{function that takes a data frame of dates and returns a data frame with the
yields for different maturities. Note year must be entered as YYYY-MM-DD.}
\usage{
getRatesDf(startDate, endDate, currency = "USD")
}
\arguments{
  \item{startDate}{date from when rate calculation starts}

  \item{endDate}{date when rate calculation ends}

  \item{currency}{for which rates are being calculated}
}
\value{
dataframe containing the rates from everyday between and
including the start and end dates. Note: the date in the
column does not refer to the rates of that day but the date
on which the CDS is being priced. So the corresponding rate
is actually the rate of the previous day. Example: if the
column reads 2014-04-22, the corresponding rates are
actually for 2014-04-21.
}
\description{
function that takes a data frame of dates and returns a
data frame with the yields for different maturities. Note
year must be entered as YYYY-MM-DD.
}

