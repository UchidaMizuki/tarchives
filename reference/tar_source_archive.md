# Run archived R scripts.

Run archived R scripts.

## Usage

``` r
tar_source_archive(
  package,
  files = "R",
  envir = targets::tar_option_get("envir"),
  change_directory = FALSE
)
```

## Arguments

- package:

  A scalar character of the package name.

- files:

  Character vector of file and directory paths to look for R scripts to
  run. Paths must either be absolute paths or must be relative to the
  current working directory just before the function call.

- envir:

  Environment to run the scripts. Defaults to `tar_option_get("envir")`,
  the environment of the pipeline.

- change_directory:

  Logical, whether to temporarily change the working directory to the
  directory of each R script before running it.

## Value

`NULL` (invisibly)
