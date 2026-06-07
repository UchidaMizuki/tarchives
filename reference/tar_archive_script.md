# Path to the archived target script file

Path to the archived target script file

## Usage

``` r
tar_archive_script(
  package,
  pipeline,
  script = targets::tar_config_get("script")
)
```

## Arguments

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

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
