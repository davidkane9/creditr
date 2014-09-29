CDS TO-DO List
========================================================
* There is too much cruft, too many LaTeX packages and so on. Delete everything (e.g., \usepackage{Sweave}) that is not being used.

* Format it to meet the requirements of submission for the Journal of Statistical Software. This is hard an may require a lot of fiddling. But don't start this until you have deleted all the cruft above since you want the cleanest possible starting place.

Some very specific formatting issue:

1. Multiple authors are overlapping

2. Need to fix figure one section reference error (the “??” error)

3. Formatting table one (which is too long right now)

4. Formatting table four (which is too long right now)

5. Equation (61) which has too much spacing above it right now

6. Equation (62) which has too much spacing above it right now

7. Bibliography should be standardized more and Knitr should be added

8. Everyone fills in the affiliation

* Delete all the images (both their inclusion and the raw image installed in the package) that do not come from our acceptable three sources: Bloomberg screenshots; Markit screen shots and the JPM powerpoint slides. This may require the replacement of lots of those images with JPM images, but the JPM images all seem better to me.

* The current quotations of variable symbols is wrong. It should not be:
  so the risk-neutral value of "P" (1\%) and the parties'
But instead
  so the risk-neutral value of $P$ (1\%) and the parties'
That is, we put every mathematical variable in its down math environment. I am pretty sure that this is standard, but, if you disaggree, speak up.
* The Bloomberg/Markit section needs a complete rewrite. Who wants to tackle that? We should have a phone conversation.


* valueDate is incorrect. See add.dates() for details, but this could be the reason for (some of) the small discrepancies we have seen. Problem arises when there is a holiday on T + 3.

* check.inputs should be re-worked. 
** We want it to work for all the different functions even though not all of them actually require all the possible input arguments. That is, if there is a need for tenor.var then check.inputs should make sure that it is in x, that it is numeric and then rename it as "tenor". If, however, tenor.var has no use, then won't be there and should be ignored. I don't think (?) that we want the output of check.inputs to provide a tenor if a tenor is not needed, although I guess that isn't doing any harm.
** Handle the incompatible options correctly. The calling function can have a recovery or a recovery.var argument. It should not have both. Same with maturity.var and tenor.var. Also, notional and notional.var.
** Maybe check.inputs only returns the variables that you specify. That is, if you only pass in a date.var, spread.var and tenor.var, then the return data frame has three columns, date, spread and tenor. This give less freedome since you can't pass in a bunch of other variables, but I don't think (?) that any of our functions need that freedom.

* Of all the variables, Rec Risk 01 was the most problematic, which is strange because its code is almost identical to IR.DV01 and spread.DV01. Perhaps it is that the default recovery rate is different in different indices. Seems to be 0.4 in the US but 0.35 in Japan.



* We want to put the package on CRAN. To do that, we can't include the c code (all the items in /src). So, how can we solve this? (Might be useful to post a question about this on stackoverflow. But Google a bunch first.) Idea: Have the package automatically go a get the files on installation and/or loading. Complications:
** Might need to create the src/ directory as well, or have an empty file in the source directory because R does not like empty directories in packages.
** "Makefile" is the typical way that this is solved in non-R contexts. Learn about Makefiles. But I don't know if R allows for the use of Makefiles. Or, if it does, exactly how this might work. Maybe "Makevars" is also relevant?
** Downloading the files from cdsmodel.com is non-trivial. (Go try it.) Because it requires checking a box, providing a (fake?) e-mail address and then dealing with a .zip file. R provides various packages and functions for dealing with these issues, but I am not an expert in their use.
** If we can't make all the above automatic, then we could, instead, still get the package on CRAN by making the process as easy as possible. That is, we still don't distribute the c code, but we provide step-by-step instructions in what to do after you have downloaded the package. This is non-trivial because it would require re-compiling the package after the user gets the c code. But it is still not a bad answer. In fact, doing this is probably a good idea because it will show you all the steps that need to be added to the Makefile.




