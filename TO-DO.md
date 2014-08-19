CDS TO-DO List
========================================================

* Perhaps types, rates and expiries could all be put into a single slot. Again, we want to tie this grouping as closely as possible into the function (mostly get.rates(), I think?) which populate it.

* Do we ever need isPriceClean an payAccruedOnDefault as arguments to functions like IR.DV01? I don't think so. So, let's remove them everywhere an hard code those default values.

* Reorganize the order of the slots in CDS.R so that they are grouped in a sensible way, with lines skipped between the major groupings. name is probably the first slot, then all the variables (like date, spread, maturity, coupon, recovery.rate, et cetera) that one needs when calling the important data.frame functions, then the date stuff, then the conventions, ending with all the things that we need to calculate like upfronts, spreadDV01 and so on.

* get.date ought to include the JPY stuff, I think. Maybe also business date stuff? Change name to add.dates.

* Fix all line wraps by reformatting code.
