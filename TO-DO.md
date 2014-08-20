CDS TO-DO List
========================================================
* Do not just delete items from this list. Do them and the put [DONE] at the beginning of them. I will then check them and delete them if I agree that it its done. You can, however, reorganize the order of the list, if that is convenient.

* create get.conventions(). This returns a one row data frame of the accounting convention variables like badDayConvention and mmDCC. All the information for this is in the R code itself, not in an extraneous data frame. Handles changes in rules for Japan. Takes a date and currency as arguments. Does not need to work for data frames, I think.

* Understand how the C code can be "tricked" into dealing with missing in interest rates. First, if we pass in nothing, what does it do? Second, if that fails, how can we pass in the simplest zero rate. Maybe just 0 at 1Y? 

* re-organize get.rates(). Should only return the actual rates, not that other junk. Should have a new argument: "stored" with default value TRUE. If TRUE, the data is gotten from the rates.RData. If false, it goes to the internet. If you ask for rates for a day that has no information in rates.RData (or if stored = FALSE and you get nothing back from the internet), then get.rates issues an informative warning (which day/currency failed) and then returns zero interest rates.

* Try to make data/rates.RData go back to Jan 1, 2004. This is how far back our pricing goes. Document clearly how this is updated.

* Drastically cut the slots of CDS class, including dates, interest.rates and conventions. We don't need to keep this stuff around, I think. Instead, we grab these items on the fly when they are needed, using add.dates(), get.rates() and get.conventions().

* In rates.RData, "rates" variable should be renamed as "rate". Also, currency and expiry should be character, not factor. This suggests that download.rates should be changed as well so that, next time we rebuild the data, we get what we want.

* What is going on with the dates in 2003 that have a 1M but not a 3Y. table(rates$expiry[rates$year %in% c(2003)])

 1M  3Y 
729 724 

DONE: I am not saying this data is wrong, but anomalies like this should be mentioned in ?rates.

DONE: * Provide much more detail in ?rates, especially about how the data  frame is created (with get.rates.DF), ultimate source (give the URL), different date ranges for different currencies, different expiry for different currencies, changes in expiries over time and so on. Also, make clear what "date" means. It is not the same as the date that these rates were in effect, right? It is the date after, so that it can match with the CDS pricing date. Explain all that. 

* Deal with the "The following files look like leftovers/mistakes" issue. There is no reason to have this. Note that I tried moving the new .Rbuildignore file down one level, into pkg/. This caused the test cases to fail, I think. (Or it might just have been an intermittent internet thing. If so, the error messages were not informative.)

* Maybe check.rates.dates is no longer necessary?
  It hasn't been used once in the package. So maybe it's not necessary.

* get.date ought to include the JPY stuff, I think. Maybe also business date stuff? Change name to add.dates.

* Fix all line wraps by reformatting code.

* Drop the maturity slot? We should discuss this.

* Things to fix in CDS.Rnw
** Read and completely understand the current version three times.
** There is too much cruft, too many LaTeX packages and so on. Delete everything (e.g., \usepackage{Sweave}) that is not being used.
** Format it to meet the requirements of submission for the Journal of Statistical Software. This is hard an may require a lot of fiddling. But don't start this until you have deleted all the cruft above since you want the cleanest possible starting place.
** Delete all the images (both their inclusion and the raw image installed in the package) that do not come from our acceptable three sources: Bloomberg screenshots; Markit screen shots and the JPM powerpoin slides. This may require the replacement of lots of those images with JPM images, but the JPM images all seem better to me.


