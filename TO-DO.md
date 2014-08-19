CDS TO-DO List
========================================================
* pd.to.spread first argument should be x, not data.
* We should mak slot names and argument names more consistent, even if this breaks some of the links to the C code. For example:
** parSpread should be spread everywhere
** recoveryRate should be recovery.rate everywhere
** TDate should be date everywhere
** entityName should be name

* Perhaps all the date variables except for date (formerly TDate) should go in a named array called "dates"? Things like: startDate, stepinDate, benchmarkDate and so on. Obviously, we should tie this array into get.dates() as closely as possible.

* Perhaps types, rates and expiries could all be put into a single slot. Again, we want to tie this grouping as closely as possible into the function (mostly get.rates(), I think?) which populate it.

* Do we ever need isPriceClean an payAccruedOnDefault as arguments to functions like IR.DV01? I don't think so. So, let's remove them everywhere an hard code those default values.

* Reorganize the order of the slots in CDS.R so that they are grouped in a sensible way, with lines skipped between the major groupings. name is probably the first slot, then all the variables (like date, spread, maturity, coupon, recovery.rate, et cetera) that one needs when calling the important data.frame functions, then the date stuff, then the conventions, ending with all the things that we need to calculate like upfronts, spreadDV01 and so on.

* get.date ought to include the JPY stuff, I think. Maybe also business date stuff? Change name to add.dates.

* Fix all line wraps by reformatting code.

* Consider simply removing slots that we never use. For example, if everywhere in the package, the value of stubCDS is "F" then it doesn't need to be a slot. We can just hard code it as "F" everywhere it is used, which is probably only in getting passed to the C functions. Note that I think that a bunch of slots can be removed in this way. (stubCDS and freqCDS have been removed and hard coded, not sure if some others can also be deleted.)

* Fix check.inputs so that it ensures that only one of maturity and tenor is passed in as input. (easy)
