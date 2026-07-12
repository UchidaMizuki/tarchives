# Read metadata from archive storage

tarchives version of
[`targets::tar_meta()`](https://docs.ropensci.org/targets/reference/tar_meta.html).
Returns the metadata of an archived pipeline's store.

## Usage

``` r
tar_meta_archive(
  package,
  pipeline,
  names = NULL,
  fields = NULL,
  targets_only = FALSE,
  complete_only = FALSE,
  store = targets::tar_config_get("store")
)
```

## Arguments

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

- names:

  Optional, names of the targets. If supplied,
  [`tar_meta()`](https://docs.ropensci.org/targets/reference/tar_meta.html)
  only returns metadata on these targets. You can supply symbols or
  `tidyselect` helpers like
  [`any_of()`](https://tidyselect.r-lib.org/reference/all_of.html) and
  [`starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html).
  If `NULL`, all names are selected.

- fields:

  Optional, names of columns/fields to select. If supplied,
  [`tar_meta()`](https://docs.ropensci.org/targets/reference/tar_meta.html)
  only returns the selected metadata columns. If `NULL`, all fields are
  selected. You can supply symbols or `tidyselect` helpers like
  [`any_of()`](https://tidyselect.r-lib.org/reference/all_of.html) and
  [`starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html).
  The `name` column is always included first no matter what you select.
  Choices:

  - `name`: name of the target or global object.

  - `type`: type of the object: either `"function"` or `"object"` for
    global objects, and `"stem"`, `"branch"`, `"map"`, or `"cross"` for
    targets.

  - `data`: hash of the output data.

  - `command`: hash of the target's deparsed command.

  - `depend`: hash of the immediate upstream dependencies of the target.

  - `seed`: random number generator seed with which the target ran. A
    target's random number generator seed is a deterministic function of
    its name. In this way, each target runs with a reproducible seed so
    someone else running the same pipeline should get the same results,
    and no two targets in the same pipeline share the same seed. (Even
    dynamic branches have different names and thus different seeds.) You
    can recover the seed of a completed target with
    `tar_meta(your_target, seed)` and run
    [`tar_seed_set()`](https://docs.ropensci.org/targets/reference/tar_seed_set.html)
    on the result to locally recreate the target's initial RNG state.

  - `path`: A list column of paths to target data. Usually, each element
    is a single path, but there could be multiple paths per target for
    file targets (i.e. `tar_target(format = "file")`).

  - `time`: `POSIXct` object with the time the target's data in storage
    was last modified. If the target stores no local file, then the time
    stamp corresponds to the time the target last ran successfully. Only
    targets that run commands have time stamps: just non-branching
    targets and individual dynamic branches. Displayed in the current
    time zone of the system. If there are multiple outputs for that
    target, as with file targets, then the maximum time is shown.

  - `size`: hash of the sum of all the bytes of the files at `path`.

  - `bytes`: total file size in bytes of all files in `path`.

  - `format`: character, one of the admissible data storage formats. See
    the `format` argument in the
    [`tar_target()`](https://docs.ropensci.org/targets/reference/tar_target.html)
    help file for details.

  - `iteration`: character, either `"list"` or `"vector"` to describe
    the iteration and aggregation mode of the target. See the
    `iteration` argument in the
    [`tar_target()`](https://docs.ropensci.org/targets/reference/tar_target.html)
    help file for details.

  - `parent`: for branches, name of the parent pattern.

  - `children`: list column, names of the children of targets that have
    them. These include buds of stems and branches of patterns.

  - `seconds`: number of seconds it took to run the target.

  - `warnings`: character string of warning messages from the last run
    of the target. Only the first 50 warnings are available, and only
    the first 2048 characters of the concatenated warning messages.

  - `error`: character string of the error message if the target
    errored.

- targets_only:

  Logical, whether to just show information about targets or also return
  metadata on functions and other global objects.

- complete_only:

  Logical, whether to return only complete rows (no `NA` values).

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

A data frame with one row per target/object and the selected fields.

## Examples

``` r
# \donttest{
withr::with_envvar(
  c(R_USER_CACHE_DIR = tempfile()),
  {
    tar_make_archive(package = "tarchives", pipeline = "example-model")
    tar_meta_archive(package = "tarchives", pipeline = "example-model")
  }
)
#> # A tibble: 3 × 18
#>   name  type  data  command depend    seed path  time                size  bytes
#>   <chr> <chr> <chr> <chr>   <chr>    <int> <lis> <dttm>              <chr> <dbl>
#> 1 drop… func… 3bda… NA      NA     NA      <chr> NA                  NA       NA
#> 2 data  stem  3d7f… ccd552… 3c845…  3.36e7 <chr> 2026-07-12 12:13:44 s106…  1066
#> 3 model stem  dfb7… c7c922… 02def…  8.09e8 <chr> 2026-07-12 12:13:44 s399…  3991
#> # ℹ 8 more variables: format <chr>, repository <chr>, iteration <chr>,
#> #   parent <chr>, children <list>, seconds <dbl>, warnings <chr>, error <chr>
# }
```
