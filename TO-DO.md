CDS TO-DO List
========================================================
DONE?: (Actually, check.inputs is only used by CS10 and its three other friends who all have similar structures. In all these four functions, date.var, currency.var, maturity.var, tenor.var, spread.var, coupon.var, notional.var, RR.var all need to be checked because they will have to be fed into add.dates or add.conventions, or call.ISDA. Since check.inputs is only used in these places, it seems that there should be little incentive to generalize check.inputs) Or maybe check.inputs is smart enough to know that it only checks and passes back the variables that you pass in. So, if you call check.inputs with date.var = 'date' and tenor.var = 'tenor' --- and no other arguments, it gives you back a data frame with just two variables: date and tenor. Might also need to have an extra.var argument which would be a list of variables to also pass back, without any checking done on them.

* Examine a test case for CDS (maybe Caesar's) very closely. We should be able to match every item on the screen shot perfectly. The only rounding that should be necessary should be rounding to match the rounding that Bloomberg uses. If we can't match it perfectly, then presumably we are doing something wrong, probably to do with dates and/or rates. Find the bug and fix it.

* Thoughts on spread(). Not saying you have to change these, but I wanted to mention them. ptsUpfront.var should be points.var. Why isn't there a notional.var? That is how we do things elsewhere. Why is there JPY.condition gibberish still in the function. Isn't this logic now in add.dates()? Maybe a better name for this function would be points.to.spread()? After all, that is the fundamental transformation that is happening. I give the function the points for a CDS, and it tells me the spread. (This is consistent with spread.to.pd().) 

* Better error messages of Internet Connection Problem

* Things to fix in CDS.Rnw
** Read and completely understand the current version three times.
** There is too much cruft, too many LaTeX packages and so on. Delete everything (e.g., \usepackage{Sweave}) that is not being used.
** Format it to meet the requirements of submission for the Journal of Statistical Software. This is hard an may require a lot of fiddling. But don't start this until you have deleted all the cruft above since you want the cleanest possible starting place.
** Delete all the images (both their inclusion and the raw image installed in the package) that do not come from our acceptable three sources: Bloomberg screenshots; Markit screen shots and the JPM powerpoint slides. This may require the replacement of lots of those images with JPM images, but the JPM images all seem better to me.

* We want to put the package on CRAN. To do that, we can't include the c code (all the items in /src). So, how can we solve this? (Might be useful to post a question about this on stackoverflow. But Google a bunch first.) Idea: Have the package automatically go a get the files on installation and/or loading. Complications:
** Might need to create the src/ directory as well, or have an empty file in the source directory because R does not like empty directories in packages.
** "Makefile" is the typical way that this is solved in non-R contexts. Learn about Makefiles. But I don't know if R allows for the use of Makefiles. Or, if it does, exactly how this might work. Maybe "Makevars" is also relevant?
** Downloading the files from cdsmodel.com is non-trivial. (Go try it.) Because it requires checking a box, providing a (fake?) e-mail address and then dealing with a .zip file. R provides various packages and functions for dealing with these issues, but I am not an expert in their use.
** If we can't make all the above automatic, then we could, instead, still get the package on CRAN by making the process as easy as possible. That is, we still don't distribute the c code, but we provide step-by-step instructions in what to do after you have downloaded the package. This is non-trivial because it would require re-compiling the package after the user gets the c code. But it is still not a bad answer. In fact, doing this is probably a good idea because it will show you all the steps that need to be added to the Makefile.

* Fix all line wraps by reformatting code.