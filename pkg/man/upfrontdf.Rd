\name{upfrontdf}
\alias{upfrontdf}
\title{Function that takes a dataframe of variables on CDSs to return a vector
of upfront values}
\usage{
upfrontdf(x, rates, currency = "USD", notional = 10000000,
  date.var = "date", spread.var = "spread", coupon.var = "coupon",
  maturity.var = "maturity")
}
\arguments{
  \item{x}{dataframe containing variables date, spread,
  coupon and maturity}

  \item{rates}{dataframe containing dates and rates for
  those dates}

  \item{currency}{of CDSs in the dataframe. By default is
  USD.}

  \item{notional}{values of CDSs in the dataframe,. By
  defualt is 10 million}

  \item{date.var}{name of the column containing dates. By
  default is "date"}

  \item{spread.var}{name of the column containing spreads.
  By default is "spread".}

  \item{coupon.var}{name of the column containing the
  coupon rates. By default is "coupon"}

  \item{maturity.var}{name of the column containing the
  maturity dates (note: this is different from tenor i.e.
  it is a proper date like "2019-06-20" and not "5Y"). By
  default is "maturity"/}
}
\value{
vector of upfront values in the same order
}
\description{
Function that takes a dataframe of variables on CDSs to
return a vector of upfront values
}

