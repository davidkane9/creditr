\name{upfrontdf}
\alias{upfrontdf}
\title{function that takes a dataframe of variables on CDSs to return a vector
of upfront values}
\usage{
upfrontdf(x, rates, currency = "USD", notional = 1e+07, date.var = "date",
  spread.var = "spread", coupon.var = "coupon", maturity.var = "maturity")
}
\arguments{
  \item{x}{dataframe containing variables date, spread,
  coupon and maturity}

  \item{rates}{dataframe containing dates and rates for
  those dates}

  \item{currency}{of CDSs in the dataframe}

  \item{notional}{values of CDSs in the dataframe}

  \item{date.var}{name of the column containing dates}

  \item{spread.var}{name of the column containing spreads}

  \item{coupon.var}{name of the column containing the
  coupon rates}

  \item{maturity.var}{name of the column containing the
  maturity dates (note: this is different from tenor i.e.
  it is a proper date like "2019-06-20" and not "5Y")}
}
\value{
vector of upfront values in the same order
}
\description{
function that takes a dataframe of variables on CDSs to
return a vector of upfront values
}

