# List the archived pipelines in a package

Returns the names of the pipelines bundled in a package's
`inst/tarchives` directory. Use it to discover which pipelines are
available before running them with
[`tar_make_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_make_archive.md)
or inspecting their targets with
[`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md).

## Usage

``` r
tar_archive_pipelines(
  package,
  envir = parent.frame(),
  script = targets::tar_config_get("script")
)
```

## Arguments

- package:

  A scalar character of the package name.

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

A character vector of pipeline names. A pipeline is a directory in
`inst/tarchives` that contains a target script file (`script`), so the
shared `R/` helper directory is not included.

## See also

[`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md)
to list the targets within a pipeline.
