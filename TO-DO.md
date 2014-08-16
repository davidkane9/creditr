CDS TO-DO List
========================================================

* Remove all (or almost all) errors and warnings from R CMD check.
 
* Add "context" to test cases (see cdsDB for examples of how this is done) so that sensible messages are printed out while test cases run.
 
* Understand what all the slots in the CDS class mean and why they matter. I may quiz you about this on Monday.

* Consider simply removing slots that we never use. For example, if everywhere in the package, the value of stubCDS is "F" then it doesn't need to be a slot. We can just hard code it as "F" everywhere it is used, which is probably only in getting passed to the C functions. Note that I think that a bunch of slots can be removed in this way.

* Make sure summary and show work, after you have made all the changes above. As long as they pass the test cases you created, you should be OK.

* Review all your notes from past conversations about things to fix and then fix them.
