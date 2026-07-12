# Read a target's value from archive storage

Read a target's value from archive storage

## Usage

``` r
tar_read_archive(
  name,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  store = targets::tar_config_get("store")
)

tar_read_archive_raw(
  name,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  store = targets::tar_config_get("store")
)
```

## Arguments

- name:

  Name of the target to read.
  [`tar_read()`](https://docs.ropensci.org/targets/reference/tar_read.html)
  expects an unevaluated symbol for the `name` argument, whereas
  [`tar_read_raw()`](https://docs.ropensci.org/targets/reference/tar_read.html)
  expects a character string.

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

- branches:

  Integer of indices of the branches to load if the target is a pattern.

- meta:

  Data frame of metadata from
  [`tar_meta()`](https://docs.ropensci.org/targets/reference/tar_meta.html).
  [`tar_read()`](https://docs.ropensci.org/targets/reference/tar_read.html)
  with the default arguments can be inefficient for large pipelines
  because all the metadata is stored in a single file. However, if you
  call
  [`tar_meta()`](https://docs.ropensci.org/targets/reference/tar_meta.html)
  beforehand and supply it to the `meta` argument, then successive calls
  to
  [`tar_read()`](https://docs.ropensci.org/targets/reference/tar_read.html)
  may run much faster.

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

The target's return value from its file in `_targets/objects/`, or the
paths to the custom files and directories if `format = "file"` was set.

## Details

`tar_read_archive()` captures `name` with non-standard evaluation,
whereas `tar_read_archive_raw()` takes it as a character string.

## Examples

``` r
# \donttest{
withr::with_envvar(
  c(R_USER_CACHE_DIR = tempfile()),
  {
    tar_make_archive(package = "tarchives", pipeline = "example-model")
    tar_read_archive(model, package = "tarchives", pipeline = "example-model")
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
