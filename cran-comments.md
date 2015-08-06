## Release summary

This is the second submission

Changes are: 

- deleted .Rprofile, which might bother with install.packages() repo path;
- set environment variables in .onLoad function to make sure environment
  variables are set before other functions are called
- changed license from MIT to GPL-3
- deleted Additional_repositories field form DESCRIPTION; explained how to get
  "creditrISDA" package in description field in DESCRIPTION (by calling
  devtools::install_github) 

---

## Test environments

* local Windows 8.1, R 3.2.1
* Linux (GNU Gnome), R 3.2.0
* Mac OS X, R 3.0.2
* win-builder (R-devel and R-release)

## R CMD check results

There were no ERRORs or WARNINGs.

There were two NOTES.

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'David Kane <dave.kane@gmail.com>'
New submission

* checking package dependencies ... NOTE
No repository set, so cyclic dependency check skipped

## Downstream dependencies

None