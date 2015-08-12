## Release summary

This is our fourth (re)submission. Last time, there were two issues which we have addressed this time:

(1) "checking sizes of PDF files under ‘inst/doc’ ... WARNING"

Solved: have reduced the size of each individual image we used.

(2) Agreement has been reached with the CRAN committee that our package can be safely redistributed by CRAN provided that we include a copy of "ISDA CDS STANDARD MODEL PUBLIC LICENSE" in the file LICENSE. We did that last time, but the description file was inaccurate.

Solution: have amended the description according to suggestion by CRAN.

---

## Test environments

* local Windows 7/8.1, R 3.2.1
* Linux (GNU Gnome), R 3.2.0
* Mac OS X, R 3.0.2
* win-builder (R-devel and R-release)

## R CMD check results

There were no ERRORs or WARNINGs.

There was 1 NOTE.

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Yuanchu Dang <yuanchu.dang@gmail.com>'
New submission
Non-FOSS package license (file LICENSE)

## Downstream dependencies

None