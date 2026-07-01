# List the targets of an archived pipeline

tarchives version of
[`targets::tar_manifest()`](https://docs.ropensci.org/targets/reference/tar_manifest.html).
Returns a data frame of the targets defined in an archived pipeline's
target script file.

## Usage

``` r
tar_manifest_archive(
  package,
  pipeline,
  names = NULL,
  fields = NULL,
  drop_missing = TRUE,
  callr_function = callr::r,
  callr_arguments = targets::tar_callr_args_default(callr_function),
  envir = parent.frame(),
  script = targets::tar_config_get("script")
)
```

## Arguments

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

- names:

  Names of the targets to show. Set to `NULL` to show all the targets
  (default). Otherwise, the object supplied to `names` should be a
  `tidyselect` expression like
  [`any_of()`](https://tidyselect.r-lib.org/reference/all_of.html) or
  [`starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html)
  from `tidyselect` itself, or
  [`tar_described_as()`](https://docs.ropensci.org/targets/reference/tar_described_as.html)
  to select target names based on their descriptions.

- fields:

  Names of the fields, or columns, to show. Set to `NULL` to show all
  the fields (default). Otherwise, the value of `fields` should be a
  `tidyselect` expression like
  [`starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html)
  to select the columns to show in the output. Possible fields are
  below. All of them can be set in
  [`tar_target()`](https://docs.ropensci.org/targets/reference/tar_target.html),
  [`tar_target_raw()`](https://docs.ropensci.org/targets/reference/tar_target.html),
  or
  [`tar_option_set()`](https://docs.ropensci.org/targets/reference/tar_option_set.html).

  - `name`: Name of the target.

  - `command`: the R command that runs when the target runs.

  - `description`: custom free-form text description of the target, if
    available.

  - `pattern`: branching pattern of the target, if applicable.

  - `format`: Storage format.

  - `repository`: Storage repository.

  - `iteration`: Iteration mode for branching.

  - `error`: Error mode, what to do when the target fails.

  - `memory`: Memory mode, when to keep targets in memory.

  - `storage`: Storage mode for high-performance computing scenarios.

  - `retrieval`: Retrieval mode for high-performance computing
    scenarios.

  - `deployment`: Where/whether to deploy the target in high-performance
    computing scenarios.

  - `priority`: Numeric of length 1 between 0 and 1. Controls which
    targets get deployed first when multiple competing targets are ready
    simultaneously. Targets with priorities closer to 1 get dispatched
    earlier (and polled earlier in
    [`tar_make_future()`](https://docs.ropensci.org/targets/reference/tar_make_future.html)).

  - `resources`: A list of target-specific resource requirements for
    [`tar_make_future()`](https://docs.ropensci.org/targets/reference/tar_make_future.html).

  - `cue_mode`: Cue mode from
    [`tar_cue()`](https://docs.ropensci.org/targets/reference/tar_cue.html).

  - `cue_depend`: Depend cue from
    [`tar_cue()`](https://docs.ropensci.org/targets/reference/tar_cue.html).

  - `cue_expr`: Command cue from
    [`tar_cue()`](https://docs.ropensci.org/targets/reference/tar_cue.html).

  - `cue_file`: File cue from
    [`tar_cue()`](https://docs.ropensci.org/targets/reference/tar_cue.html).

  - `cue_format`: Format cue from
    [`tar_cue()`](https://docs.ropensci.org/targets/reference/tar_cue.html).

  - `cue_repository`: Repository cue from
    [`tar_cue()`](https://docs.ropensci.org/targets/reference/tar_cue.html).

  - `cue_iteration`: Iteration cue from
    [`tar_cue()`](https://docs.ropensci.org/targets/reference/tar_cue.html).

  - `packages`: List columns of packages loaded before running the
    target.

  - `library`: List column of library paths to load the packages.

- drop_missing:

  Logical of length 1, whether to automatically omit empty columns and
  columns with all missing values.

- callr_function:

  A function from `callr` to start a fresh clean R process to do the
  work. Set to `NULL` to run in the current session instead of an
  external process (but restart your R session just before you do in
  order to clear debris out of the global environment). `callr_function`
  needs to be `NULL` for interactive debugging, e.g.
  `tar_option_set(debug = "your_target")`. However, `callr_function`
  should not be `NULL` for serious reproducible work.

- callr_arguments:

  A list of arguments to `callr_function`.

- envir:

  An environment, where to run the target R script (default:
  `_targets.R`) if `callr_function` is `NULL`. Ignored if
  `callr_function` is anything other than `NULL`. `callr_function`
  should only be `NULL` for debugging and testing purposes, not for
  serious runs of a pipeline, etc.

  The `envir` argument of
  [`tar_make()`](https://docs.ropensci.org/targets/reference/tar_make.html)
  and related functions always overrides the current value of
  `tar_option_get("envir")` in the current R session just before running
  the target script file, so whenever you need to set an alternative
  `envir`, you should always set it with
  [`tar_option_set()`](https://docs.ropensci.org/targets/reference/tar_option_set.html)
  from within the target script file. In other words, if you call
  `tar_option_set(envir = envir1)` in an interactive session and then
  `tar_make(envir = envir2, callr_function = NULL)`, then `envir2` will
  be used.

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

A data frame of information about the targets in the pipeline. Rows
appear in topological order (the order they will run without any
influence from parallel computing or priorities).

## See also

[`tar_archive_pipelines()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_pipelines.md)
to list the pipelines in a package.
