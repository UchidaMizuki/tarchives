
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tarchives

<!-- badges: start -->

[![R-CMD-check](https://github.com/UchidaMizuki/tarchives/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/UchidaMizuki/tarchives/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of tarchives is to make targets pipelines into a package. It
runs ‘targets’ pipeline in /inst/tarchives and stores the results in the
R user directory. This means that the user does not have to run the
process repeatedly, and the developer has the flexibility to update the
data as versions are updated.

## Installation

You can install the development version of tarchives from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("UchidaMizuki/tarchives")
```

## Functions

- `tar_archive()`: Convert the targets function to tarchives version.
- `tar_make_archive()`: tarchives version of `targets::tar_make()`
  function.
- `tar_read_archive()`: tarchives version of `targets::tar_read()`
  function.
- `tar_target_archive()`: tarchives version of `targets::tar_target()`
  function.
