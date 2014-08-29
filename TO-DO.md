CDS TO-DO List
========================================================
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

Kanishka's note on what test cases to add
========================================================


* maturity date （endDate) does not need to be a weekday. It remains unfixed, and has to be roll date.
* coupondate must be a weekday; if the roll date is a weekend day, coupon date has to be adjusted to business day.
* Accrual Start Date must be a weekday. if the rolldate before trade date is a weekend day, accrual start date must be adjusted to next business day.
*Accrual End Date (not end date or maturity date, which must be fixed) does not have to be a weekday: for example, if the second coupon payment date is Mon 6/22/2009 (because 6/20/2009 is a weekend day), then the Accrual end date is 6/21/2009, a Sunday.
* So according to ISDA date convention pdf, start date and benchmark start date is the same as accrual begin date, this means that startDate and benchmarkDate must be weekdays.
* Also, there exists a confusion for valueDate: if you check out ISDA date convention pdf, you will find that if you are calculating "cash settlement from spread" or "spread from upfront", then valueDate = Trade date + 3, which also means that valueDate can also be a weekend. else if you are "building a yield curve", then valueDate = Trade Date + 2 weekdays (Non-JPY) or Trade Date + 2 business days (JPY), which also means that valueDate can be a weekend.
* But right now, in our CDS package, I "think" we are treating valueDate = Trade Date + 2 business days/weekdays everywhere
* And I "think" we are coercing valueDate to be a business day. 

* Rec Risk 01 was problematic. More test cases needed there (ask for BB screenshots from Dave).
(RecRisk shouldn't be more problematic, because its code is almost identical to IR.DV01 and spread.DV01,
maybe it's just that the effect of change in RecRisk is bigger than other variable, so it seems that 
the code of RecRisk is more problematic)

* PV.01 test case if George provides the true values to test against.

