# Path to the archived target store directory

Path to the archived target store directory

## Usage

``` r
tar_archive_store(package, pipeline, store = targets::tar_config_get("store"))
```

## Arguments

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

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

A scalar character of the path to the archived target store directory.

## Examples

``` r
tar_archive_store(package = "tarchives", pipeline = "example-model")
#> /home/runner/.cache/R/tarchives/tarchives/example-model/_targets
```
