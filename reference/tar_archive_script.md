# Path to the archived target script file

Path to the archived target script file

## Usage

``` r
tar_archive_script(
  package,
  pipeline,
  envir = parent.frame(),
  script = targets::tar_config_get("script")
)
```

## Arguments

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

- envir:

  An environment used to resolve `package`, so that a package currently
  loaded with
  [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
  (e.g. during interactive package development) is resolved to its
  source directory instead of its installed one. Defaults to the calling
  environment.

- script:

  Character of length 1, path to the target script file. Defaults to
  `tar_config_get("script")`, which in turn defaults to `_targets.R`.
  When you set this argument, the value of `tar_config_get("script")` is
  temporarily changed for the current function call. See
  [`tar_script()`](https://docs.ropensci.org/targets/reference/tar_script.html),
  [`tar_config_get()`](https://docs.ropensci.org/targets/reference/tar_config_get.html),
  and
  [`tar_config_set()`](https://docs.ropensci.org/targets/reference/tar_config_set.html)
  for details about the target script file and how to set it
  persistently for a project.

## Value

A scalar character of the path to the archived target script file.

## Examples

``` r
tar_archive_script(package = "tarchives", pipeline = "example-model")
#> /home/runner/work/_temp/Library/tarchives/tarchives/example-model/_targets.R
```
