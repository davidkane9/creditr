\name{pd.spread}
\alias{pd.spread}
\title{function to calculate spread using the probability of default, time and recovery rate}
\usage{
pd.spread(PD, tenor, TDate = Sys.Date(), Recovery = 0.4)
}
\arguments{
  \item{Recovery}{rate in decimals}

  \item{PD}{probability of default in decimals}

  \item{tenor}{in years}

  \item{TDate}{trade date. By default is the current date}
}
\value{
spread in basis points, calculated by inverting the formula
for probability of default given in the Bloomberg Manual
}
\description{
function to calculate spread using the probability of
default, time and recovery rate
}

