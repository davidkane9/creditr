CDS TO-DO List
========================================================
DONE: Make implied.RR() more like other functions. For example, argument "data" should be "x". "end.date"" should be "maturity.var". "date.var" should be the first argument after x. And so on. Might also consider allowing for a "tenor.var" in place of a maturity.var since that is the more common usage.

DONE: PV.01() should be PV01(). Also, it should no coerce variables like principal.var to numeric. It should stopifnot they aren't numeric.

DONE: upfront.R is very different than the other functions. For example, instead of using add.dates() and add.conventions(), it does a bunch of stuff by-hand. This seems undesirable. Is there a reason it has to be this way? If so, that reason should be documented in the code! If not, then we should change it. Also, recovery.var = "recovery" is not consistent with our other usage. Elsewhere, it is RR.var = "recovery.rate". We need to be consistent and this second convention seems better.

DONE: I think that the convention of changing all the variable names works OK:

  colnames(x)[which(colnames(x) == date.var)] <- "date"
  
But we do this in a bunch of places. Better to encapsulate this code in check.inputs(). That is, check.inputs should do this renaming for us, returning a data frame with just the variables we need, named the way we want them to be named. This makes spread.DV01 and friends even easier to understand/maintain. The main complexity, of course, is that not every function needs the same set of variables, so there might need to be one or two that are left out of check.inputs. That is OK. Those could be handled by hand in whichever functions need them. 

DONE: upfront and ptsUpfront are both slots. Does that make sense? Isn't one a direct mathetical function of the other? If so, we should only keep one. Also, would "points" might be a better name than ptsUpfront.

* Examine a test case for CDS (maybe Caesar's) very closely. We should be able to match every item on the screen shot perfectly. The only rounding that should be necessary should be rounding to match the rounding that Bloomberg uses. If we can't match it perfectly, then presumably we are doing something wrong, probably to do with dates and/or rates. Find the bug and fix it.

* Or maybe check.inputs is smart enough to know that it only checks and passes back the variables that you pass in. So, if you call check.inputs with date.var = 'date' and tenor.var = 'tenor' --- and no other arguments, it gives you back a data frame with just two variables: date and tenor. Might also need to have an extra.var argument which would be a list of variables to also pass back, without any checking done on them.

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




