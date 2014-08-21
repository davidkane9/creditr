CDS TO-DO List
========================================================
DONE: In rates.RData, "rates" variable should be renamed as "rate". Also, currency and expiry should be character, not factor. Also, no GDP in rates. This suggests that download.rates (or maybe this is handled in get.rates?) should be changed as well so that, next time we rebuild the data, we get what we want. In fact, do this and rebuild now. And then compare the old with the new. Did anything weird happen?

DONE: After you mark an item [DONE], move it to the top of the list so that I notice it. As a test, do that with this item, now that you have read it.

DONE: Check inputs ought to provide some useful default behavior
** It should only pass back the columns that are needed going forward. That is, even if input x has 50 columns, check.inputs only passes back the columns that need to be kept around.
** Instead of just failing if something like notional.var is missing, it ought to create a x$notional column and give it a sensible default value. If any of these are missing, don't fail, just create with the default name: date.var with today's date. tenor.var with 5, notional.var with 10,000,000 and RR.var with 0.4.


* Update ?rates with lots of information.

* Change get.rates.DF (and associated helper functions) so that it goes back to January 1, 2004 for all three currencies.

* Make data/rates.RData go back to January 1, 2004. This is how far back our pricing goes. Document clearly how this is updated.


* Add all the test cases specified at the bottom of test.rates.R

* create call.ISDA to centralize the calling of ISDA C code from res.risk.01, spread.DV01 and CS10. Something like:

call.ISDA(x, name, ...)

where x is a data frame that looks like the result after add.dates() and add.conventions. name is a character like "CS10". Indeed, should be the same character string as the calling function. And the ... includes whatever other arguments you need to pass in.


* Drastically cut the slots of CDS class, including dates, interest.rates and conventions. We don't need to keep this stuff around, I think. Instead, we grab these items on the fly when they are needed, using add.dates(), get.rates() and get.conventions().


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


