\name{upfrontdf}
\alias{upfrontdf}
\title{Function that takes a dataframe of variables on CDSs to return a vector of
upfront values. Note that all CDS in the data frame must be denominated in
the same currency.}
\usage{
upfrontdf(x, rates, currency = "USD", notional = 10000000,
  date.var = "date", spread.var = "spread", coupon.var = "coupon",
  maturity.var = "maturity")
}
\arguments{
  \item{x}{dataframe containing variables date, spread,
  coupon and maturity}

  \item{rates}{dataframe containing dates and rates for
  those dates. Note that the date column over here refers
  to the date for which the adjacent interest rate curve
  would apply. So if it says "2014-07-25", the interest
  rate curve is from "2014-07-24".}

  \item{currency}{of CDSs in the dataframe. By default is
  USD. Note that at a time, we can only provide CDS data of
  a single currency.}

  \item{notional}{values of CDSs in the dataframe,. By
  defualt is 10 million}

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
vector of upfront values (with accrual) in the same order
}
\description{
Function that takes a dataframe of variables on CDSs to
return a vector of upfront values. Note that all CDS in the
data frame must be denominated in the same currency.
}

