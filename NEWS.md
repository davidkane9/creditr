# creditr 0.4-4

* second submission

- deleted .Rprofile, which might bother with install.packages() repo path;
- set environment variables in .onLoad function to make sure environment
  variables are set before other functions are called
- changed license from MIT to GPL-3
- deleted Additional_repositories field form DESCRIPTION; explained how to get
  "creditrISDA" package in description field in DESCRIPTION (by calling
  devtools::install_github) 