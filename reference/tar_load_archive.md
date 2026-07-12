# Load a target's value from archive storage

tarchives version of
[`targets::tar_load()`](https://docs.ropensci.org/targets/reference/tar_load.html).
Reads one or more targets from an archived pipeline's store and assigns
them into an environment.

## Usage

``` r
tar_load_archive(
  names,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  strict = TRUE,
  silent = FALSE,
  envir = parent.frame(),
  store = targets::tar_config_get("store")
)
```

## Arguments

- names:

  Names of the targets to load.
  [`tar_load()`](https://docs.ropensci.org/targets/reference/tar_load.html)
  uses non-standard evaluation in the `names` argument (example:
  `tar_load(names = everything())`), whereas
  [`tar_load_raw()`](https://docs.ropensci.org/targets/reference/tar_load.html)
  uses standard evaluation for `names` (example:
  `tar_load_raw(names = quote(everything()))`).

  The object supplied to `names` should be a `tidyselect` expression
  like [`any_of()`](https://tidyselect.r-lib.org/reference/all_of.html)
  or
  [`starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html)
  from `tidyselect` itself, or
  [`tar_described_as()`](https://docs.ropensci.org/targets/reference/tar_described_as.html)
  to select target names based on their descriptions.

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

- branches:

  Integer of indices of the branches to load for any targets that are
  patterns.

- meta:

  Data frame of target metadata from
  [`tar_meta()`](https://docs.ropensci.org/targets/reference/tar_meta.html).

- strict:

  Logical of length 1, whether to error out if one of the selected
  targets is in the metadata but cannot be loaded. Set to `FALSE` to
  just load the targets in the metadata that can be loaded and skip the
  others.

- silent:

  Logical of length 1. Only relevant when `strict` is `FALSE`. If
  `silent` is `FALSE` and `strict` is `FALSE`, then a message will be
  printed if a target is in the metadata but cannot be loaded. However,
  load failures will not stop other targets from being loaded.

- envir:

  R environment in which to load target return values.

- store:

  Character of length 1, directory path to the data store of the
  pipeline.

## Value

Nothing.

## Examples

``` r
# \donttest{
withr::with_envvar(
  c(R_USER_CACHE_DIR = tempfile()),
  {
    tar_make_archive(package = "tarchives", pipeline = "example-model")
    tar_load_archive(model, package = "tarchives", pipeline = "example-model")
    model
  }
)
#> 
#> Call:
#> lm(formula = Sepal.Width ~ Sepal.Length, data = data)
#> 
#> Coefficients:
#>  (Intercept)  Sepal.Length  
#>        1.131         0.278  
#> 
# }
```
