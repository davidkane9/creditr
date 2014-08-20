CDS TO-DO List
========================================================
* create get.conventions(). This returns a one row data frame of the accounting convention variables like 

* re-organize get.rates(). I think that this should probably only return the actual rates, not that other junk. The other junk should be permanently stored in a data frame in /data. But first check that it never changes, not matter how far back you go.

* Try to make data/rates.RData go back to Jan 1, 2004. This is how far back our pricing goes.

* Maybe check.rates.dates should handle missing rates with a warning and setting the rates to zero.

* Fix behavior for the case when get.rates() returns nothing. I think that, in this case, we want all interest rates to be zero (with a warning) 

* get.date ought to include the JPY stuff, I think. Maybe also business date stuff? Change name to add.dates.

* Fix all line wraps by reformatting code.

* Drop the maturity slot? We should discuss this.

* Things to fix in CDS.Rnw
** Read and completely understand the current version three times.
** There is too much cruft, too many LaTeX packages and so on. Delete everything (e.g., \usepackage{Sweave}) that is not being used.
** Format it to meet the requirements of submission for the Journal of Statistical Software. This is hard an may require a lot of fiddling. But don't start this until you have deleted all the cruft above since you want the cleanest possible starting place.
** Delete all the images (both their inclusion and the raw image installed in the package) that do not come from our acceptable three sources: Bloomberg screenshots; Markit screen shots and the JPM powerpoin slides. This may require the replacement of lots of those images with JPM images, but the JPM images all seem better to me.

* Create get.conventions() to take over the second functionality of get.rates(). This can be hard coded with "if" statements without using fancy data frame.

* Drastically cut the slots of CDS class, including dates, interest.rates and conventions.