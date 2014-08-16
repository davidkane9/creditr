CDS TO-DO List
========================================================

* Remove all (or almost all) errors and warnings from R CMD check.
 
* Add "context" to test cases (see cdsDB for examples of how this is done) so that sensible messages are printed out while test cases run.
 
* Understand what all the slots in the CDS class mean and why they matter. I may quiz you about this on Monday.

* Reorganize CDS class. We want CDS to be simpler, to not have 25+ slots. I am flexible about exactly how this is put together. To do this task, you will need to spend time learning more about CDS and spend time learning/reviewing S4 classes in R. For now, keep just the one class but turn some of the slots into named arrays. For example, maybe these slots (mmDCC mmCalendars fixedDCC floatDCC fixedFreq floatFreq swapCalendars) could be combined into a named array stored in a slot called IR.conventions. Maybe other things belong here also, things like: dccCDS, freqCDS, stubCDS and badDayConvCDS?

* Consider simply removing slots that we never use. For example, if everywhere in the package, the value of stubCDS is "F" then it doesn't need to be a slot. We can just hard code it as "F" everywhere it is used, which is probably only in getting passed to the C functions. Note that I think that a bunch of slots can be removed in this way.

* Make sure summary and show work, after you have made all the changes above. As long as they pass the test cases you created, you should be OK.

* Review all your notes from past conversations about things to fix and then fix them.
