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
including the start and end dates
}
\description{
function that takes a data frame of dates and returns a
data frame with the yields for different maturities. Note
year must be entered as YYYY-MM-DD.
}

