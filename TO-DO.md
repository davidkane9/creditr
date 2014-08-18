CDS TO-DO List
========================================================
* IRDV01 (and similar functions) do too much in the loop. All (?) the date stuff can be pulled oustide the loop and done on the input data frame as a whole. To do this, make get.date take a data frame as its first argument and return a new data frame with extra variables added on, after making sure that they do not already exist in the passed in data frame.

* get.date ought to include the JPY stuff, I think. Maybe also business date stuff?

* Fix all line wraps by reformatting code.

* Understand what all the slots in the CDS class mean and why they matter. I may quiz you about this on Monday.

* Consider simply removing slots that we never use. For example, if everywhere in the package, the value of stubCDS is "F" then it doesn't need to be a slot. We can just hard code it as "F" everywhere it is used, which is probably only in getting passed to the C functions. Note that I think that a bunch of slots can be removed in this way.
