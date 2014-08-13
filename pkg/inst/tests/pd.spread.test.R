## test case for pd.spread

library(CDS)

expect_that(round(pd.spread(PD=0.1319, tenor="5Y", TDate="2014-06-24")), equals(160))
