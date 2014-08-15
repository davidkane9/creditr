CDS TO-DO List
========================================================
* Create test cases for all the examples that Kanishka came up with. If those test cases currently fail because our code does not produce the right answers, that is OK. Comment them out. But we still want the test cases.
* Create test cases for summary and show. (I think that testthat has tools for testing things that write to the screen.) Should do this before making the changes below in class structure. That way, you can be sure that your changes are not messing up these functions.
* Make all test cases pass.
* Remove all (or almost all) errors and warnings from R CMD check.
* Add "context" to test cases (see cdsDB for examples of how this is done) so that sensible messages are printed out while test cases run.
* Make sure the vignette compiles and looks OK. We can worry about content later.
* Understand what all the slots in the CDS class mean and why they matter. I may quiz you about this on Monday.
* Reorganize CDS class. We want CDS to be simpler, to not have 25+ slots. I am flexible about exactly how this is put together. To do this task, you will need to spend time learning more about CDS and spend time learning/reviewing S4 classes in R. For now, keep just the one class but turn some of the slots into named arrays. For example, maybe these slots (mmDCC mmCalendars fixedDCC floatDCC fixedFreq floatFreq swapCalendars) could be combined into a named array stored in a slot called IR.conventions. Maybe other things belong here also, things like: dccCDS, freqCDS, stubCDS and badDayConvCDS?
* Consider simply removing slots that we never use. For example, if everywhere in the package, the value of stubCDS is "F" then it doesn't need to be a slot. We can just hard code it as "F" everywhere it is used, which is probably only in getting passed to the C functions. Note that I think that a bunch of slots can be removed in this way.
* Use the inherits parameters trick that Miller discovered to simplify the function documentation.
* Make sure all the data frame functions have test cases.
* Make sure summary and show work, after you have made all the changes above. As long as they pass the test cases you created, you should be OK.
* Review all your notes from past conversations about things to fix and then fix them.
