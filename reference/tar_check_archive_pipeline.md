# Check a pipeline or target name

Validates `pipeline` against the pipelines bundled in `package` (see
[`tar_archive_pipelines()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_pipelines.md)),
or `name` against the targets defined in a pipeline (see
[`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md)).
Errors with a "did you mean" suggestion when the value doesn't match, so
callers don't have to reimplement this check themselves.

## Usage

``` r
tar_check_archive_pipeline(
  pipeline,
  package,
  envir = parent.frame(),
  arg_nm = rlang::caller_arg(pipeline),
  error_call = rlang::caller_env()
)

tar_check_archive_name(
  name,
  package,
  pipeline,
  envir = parent.frame(),
  arg_nm = rlang::caller_arg(name),
  error_call = rlang::caller_env()
)
```

## Arguments

- pipeline, name:

  A scalar character of the pipeline or target name to check.

- package:

  A scalar character of the package name.

- envir:

  An environment used to resolve `package`, so that a package currently
  loaded with
  [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
  (e.g. during interactive package development) is resolved to its
  source directory instead of its installed one. Defaults to the calling
  environment.

- arg_nm, error_call:

  Passed to
  [`rlang::arg_match0()`](https://rlang.r-lib.org/reference/arg_match.html)
  to attribute the error to the correct argument and call.

## Value

`pipeline` or `name`, invisibly, if valid. Otherwise, throws an error.

## See also

[`tar_archive_pipelines()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_pipelines.md)
to list the pipelines in a package, and
[`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md)
to list the targets within a pipeline.

## Examples

``` r
tar_check_archive_pipeline("example-model", package = "tarchives")
#> [1] "example-model"

# \donttest{
withr::with_envvar(
  c(R_USER_CACHE_DIR = tempfile()),
  tar_check_archive_name(
    "data",
    package = "tarchives",
    pipeline = "example-model"
  )
)
#> [1] "data"
# }
```
