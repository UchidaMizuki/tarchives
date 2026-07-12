# Destroy an archived pipeline's storage

tarchives version of
[`targets::tar_destroy()`](https://docs.ropensci.org/targets/reference/tar_destroy.html).
Removes the cached `targets` store of an archived pipeline from the R
user cache directory (`tools::R_user_dir("tarchives", "cache")`).

## Usage

``` r
tar_destroy_archive(
  package,
  pipeline,
  destroy = "all",
  batch_size = 1000L,
  verbose = TRUE,
  ask = NULL,
  store = targets::tar_config_get("store")
)
```

## Arguments

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

- destroy:

  Character of length 1, what to destroy. Choices:

  - `"all"`: entire data store (default: `_targets/`) including cloud
    data, as well as download/upload scratch files.

  - `"cloud"`: cloud data, including metadata, target definition object
    data from targets with `tar_target(..., repository = "aws")`, and
    workspace files saved on the cloud. Also deletes temporary staging
    files in `file.path(tempdir(), "targets")` that may have been
    accidentally left over from incomplete uploads or downloads.

  - `"local"`: all the local files in the data store but nothing on the
    cloud.

  - `"meta"`: metadata file at `meta/meta` in the data store, which
    invalidates all the targets but keeps the data.

  - `"process"`: progress data file at `meta/process` in the data store,
    which resets the metadata of the main process.

  - `"progress"`: progress data file at `meta/progress` in the data
    store, which resets the progress tracking info.

  - `"objects"`: all the target return values in `objects/` in the data
    store but keep progress and metadata. Dynamic files are not deleted
    this way.

  - `"scratch"`: temporary files in saved during
    [`tar_make()`](https://docs.ropensci.org/targets/reference/tar_make.html)
    that should automatically get deleted except if R crashed.

  - `"workspaces"`: compressed lightweight files locally saved to the
    `workspaces/` folder in the data store with the saved workspaces of
    targets. Does not delete workspace files on the cloud. For that,
    consider `destroy = "all"` or `destroy = "cloud"`. See
    [`tar_workspace()`](https://docs.ropensci.org/targets/reference/tar_workspace.html)
    for details.

  - `"user"`: custom user-supplied files in the `user/` folder in the
    data store.

- batch_size:

  Positive integer between 1 and 1000, number of target definition
  objects to delete from the cloud with each HTTP API request. Currently
  only supported for AWS. Cannot be more than 1000.

- verbose:

  Logical of length 1, whether to print console messages to show
  progress when deleting each batch of targets from each cloud bucket.
  Batched deletion with verbosity is currently only supported for AWS.

- ask:

  Logical of length 1, whether to pause with a menu prompt before
  deleting files. To disable this menu, set the `TAR_ASK` environment
  variable to `"false"`. `usethis::edit_r_environ()` can help set
  environment variables.

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

`NULL` (invisibly).

## Examples

``` r
# \donttest{
withr::with_envvar(
  c(R_USER_CACHE_DIR = tempfile()),
  {
    tar_make_archive(package = "tarchives", pipeline = "example-model")
    tar_destroy_archive(package = "tarchives", pipeline = "example-model", ask = FALSE)
  }
)
# }
```
