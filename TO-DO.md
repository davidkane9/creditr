CDS TO-DO List
========================================================
DONE: * Clean up build.rates(). First, make use of seealso in the documentation, including, obviously, download.markit, download.FRED and rates. Second, there are no comments! Why are those dates hard-coded? (I know that it is because Markit only goes back so far, but you need to explain that.) Also, you should at least mention that the date you are getting from markit is the date as it appeared in markit but that the date you are getting from FRED is adjusted. (You don't have to repeat all the comments that give the details, but it is wise to at least mention the date issue.) Third, add some error checking. It is fine if you restrict the function to only working with a start before 2004 and a finish after 2006 (or whatever) but, right now, I think (?) it blows up if, for example, end is in 2004. You don't have to handle all possible usages (that would be a big bother) but you should prevent the user from using the function in bad ways by checking and stopifnot the inputs.

DONE: * rates.RData should be sorted, first by date descending, then, within date, by currency ascending and then, finally, by expiry ascending with months first and then years in the right order. This last sort may be hard to do since it is not a natural sort. temporarily changing expiry to an ordered factor, sorting, and then changing it back to character, is one approach. This all goes at the end of build.rates()

* Examples and tests take FOREVER to run. This makes the package way too hard to work on. Use Rprofile and other tools to figure out where the delays comes from and then fix them. You can use dontrun on any example that takes too long, like build.rates().

* Take a tour of all functions and add whatever seealso documentation seems like a good idea. (Don't add things just for the sake of adding them. Only add them when it makes sense to do so.)

* call.ISDA should have the usual error-checking. x is a data frame, with all the appropriate variable names and so on.
 
* Better error messages of Internet Connection Problem

* Make spread and upfront similar format as CS10 which take dataframe and return vectors.

* On the other hand, get.rates should first consult the stored rates dataframe before trying markit. If still no rates, it fails. It does not check FRED (because that is too complex and/or requires making too many assumptions about what expiries exist).

* Examine a test case for CDS (maybe Caesar's) very closely. We should be able to match every item on the screen shot perfectly. The only rounding that should be necessary should be rounding to match the rounding that Bloomberg uses. If we can't match it perfectly, then presumably we are doing something wrong, probably to do with dates. Find the bug and fix it.

* We want to put the package on CRAN. To do that, we can't include the c code (all the items in /src). So, how can we solve this? (Might be useful to post a question about this on stackoverflow. But Google a bunch first.) Idea: Have the package automatically go a get the files on installation and/or loading. Complications:
** Might need to create the src/ directory as well, or have an empty file in the source directory because R does not like empty directories in packages.
** "Makefile" is the typical way that this is solved in non-R contexts. Learn about Makefiles. But I don't know if R allows for the use of Makefiles. Or, if it does, exactly how this might work. Maybe "Makevars" is also relevant?
** Downloading the files from cdsmodel.com is non-trivial. (Go try it.) Because it requires checking a box, providing a (fake?) e-mail address and then dealing with a .zip file. R provides various packages and functions for dealing with these issues, but I am not an expert in their use.
** If we can't make all the above automatic, then we could, instead, still get the package on CRAN by making the process as easy as possible. That is, we still don't distribute the c code, but we provide step-by-step instructions in what to do after you have downloaded the package. This is non-trivial because it would require re-compiling the package after the user gets the c code. But it is still not a bad answer. In fact, doing this is probably a good idea because it will show you all the steps that need to be added to the Makefile.

* Fix all line wraps by reformatting code.

* Things to fix in CDS.Rnw
** Read and completely understand the current version three times.
** There is too much cruft, too many LaTeX packages and so on. Delete everything (e.g., \usepackage{Sweave}) that is not being used.
** Format it to meet the requirements of submission for the Journal of Statistical Software. This is hard an may require a lot of fiddling. But don't start this until you have deleted all the cruft above since you want the cleanest possible starting place.
** Delete all the images (both their inclusion and the raw image installed in the package) that do not come from our acceptable three sources: Bloomberg screenshots; Markit screen shots and the JPM powerpoin slides. This may require the replacement of lots of those images with JPM images, but the JPM images all seem better to me.


