# Use tarchives

Set up tarchives for an existing package.

## Usage

``` r
use_tarchives(store = targets::tar_config_get("store"))
```

## Arguments

- store:

  Character of length 1, path to the `targets` data store. Defaults to
  `tar_config_get("store")`, which in turn defaults to `_targets/`. When
  you set this argument, the value of `tar_config_get("store")` is
  temporarily changed for the current function call. See
  [`tar_config_get()`](https://docs.ropensci.org/targets/reference/tar_config_get.html)
  and
  [`tar_config_set()`](https://docs.ropensci.org/targets/reference/tar_config_set.html)
  for details about how to set the data store path persistently for a
  project.

## Value

No return value, called for side effects.

## Examples

``` r
withr::with_tempdir(
  use_tarchives()
)
#> Adding '^inst/tarchives/.*/_targets$' to '.Rbuildignore'
```
