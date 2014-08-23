CDS TO-DO List
========================================================
DONE: * Add your names as authors of the package and of CDS.Rnw.
========================================================
call.ISDA:
NOT DONE, (x should be the first argument, like it almost always is, and name the second. Also, the code is fairly sloppy, don't you think? None of the arguments should have defaults. Are there any test cases? Et cetera.) 

"Create call.ISDA to centralize the calling of ISDA C code from res.risk.01, spread.DV01 and CS10. Something like:

call.ISDA(x, name, ...)

where x is a data frame that looks like the result after add.dates() and add.conventions. name is a character like "CS10". Indeed, should be the same character string as the calling function. And the ... includes whatever other arguments you need to pass in."

* Fix call.ISDA so that, instead of taking in a huge data frame and an "i" for the row number, it just takes in a data frame with a single row. Isn't that obviously better? It is the job of the function which calls call.ISDA to pass in the right row each time.
========================================================
* Make spread and upfront similar format as CS10 which take dataframe and return vectors.

* Fix the hard coded expiries problem in upfront.

* Make build.rates() a separate function from get.rates. Its sole purpose is to generate rates dataframe. build.rates() should consist of download.markit() and download.FRED(). 

* Change build.rates() (and associated helper functions) so that rates goes back to January 1, 2004 for all three currencies.

* On the other hand, get.rates should first consult the stored rates dataframe before trying markit. If still no rates, it fails. It does not check FRED (because that is too complex and/or requires making too many assumptions about what expiries exist).

* I don't think we need slots for inputPriceClean or payAccruedOnDefault because they always take the same value, so we can just hard code them. And then, we also don't need them as an input argument in any function. Assuming I am correct, remove the slots, remove the input arguments, and hard code the single value that each takes in the c code.

* Examine a test case for CDS (maybe Caesar's) very closely. We should be able to match every item on the screen shot perfectly. The only rounding that should be necessary should be rounding to match the rounding that Bloomberg uses. If we can't match it perfectly, then presumably we are doing something wrong, probably to do with dates. Find the bug and fix it.


* What is going on with the dates in 2003 that have a 1M but not a 3Y. table(rates$expiry[rates$year %in% c(2003)])

 1M  3Y 
729 724 

* We want to put the package on CRAN. To do that, we can't include the c code (all the items in /src). So, how can we solve this? (Might be useful to post a question about this on stackoverflow. But Google a bunch first.) Idea: Have the package automatically go a get the files on installation and/or loading. Complications:
** Might need to create the src/ directory as well, or have an empty file in the source directory because R does not like empty directories in packages.
** "Makefile" is the typical way that this is solved in non-R contexts. Learn about Makefiles. But I don't know if R allows for the use of Makefiles. Or, if it does, exactly how this might work. Maybe "Makevars" is also relevant?
** Downloading the files from cdsmodel.com is non-trivial. (Go try it.) Because it requires checking a box, providing a (fake?) e-mail address and then dealing with a .zip file. R provides various packages and functions for dealing with these issues, but I am not an expert in their use.
** If we can't make all the above automatic, then we could, instead, still get the package on CRAN by making the process as easy as possible. That is, we still don't distribute the c code, but we provide step-by-step instructions in what to do after you have downloaded the package. This is non-trivial because it would require re-compiling the package after the user gets the c code. But it is still not a bad answer. In fact, doing this is probably a good idea because it will show you all the steps that need to be added to the Makefile.

* Fix all line wraps by reformatting code.

* Drop the maturity slot? We should discuss this.

* Things to fix in CDS.Rnw
** Read and completely understand the current version three times.
** There is too much cruft, too many LaTeX packages and so on. Delete everything (e.g., \usepackage{Sweave}) that is not being used.
** Format it to meet the requirements of submission for the Journal of Statistical Software. This is hard an may require a lot of fiddling. But don't start this until you have deleted all the cruft above since you want the cleanest possible starting place.
** Delete all the images (both their inclusion and the raw image installed in the package) that do not come from our acceptable three sources: Bloomberg screenshots; Markit screen shots and the JPM powerpoin slides. This may require the replacement of lots of those images with JPM images, but the JPM images all seem better to me.


