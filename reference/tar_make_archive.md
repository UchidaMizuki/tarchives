# Run an archived pipeline of targets.

Run an archived pipeline of targets.

## Usage

``` r
tar_make_archive(
  package,
  pipeline,
  names = NULL,
  shortcut = targets::tar_config_get("shortcut"),
  reporter = "silent",
  seconds_meta_append = targets::tar_config_get("seconds_meta_append"),
  seconds_meta_upload = targets::tar_config_get("seconds_meta_upload"),
  seconds_reporter = targets::tar_config_get("seconds_reporter"),
  seconds_interval = targets::tar_config_get("seconds_interval"),
  callr_function = callr::r,
  callr_arguments = targets::tar_callr_args_default(callr_function, reporter),
  envir = parent.frame(),
  script = targets::tar_config_get("script"),
  store = targets::tar_config_get("store"),
  garbage_collection = NULL,
  use_crew = targets::tar_config_get("use_crew"),
  terminate_controller = TRUE,
  as_job = targets::tar_config_get("as_job")
)
```

## Arguments

- package:

  A scalar character of the package name.

- pipeline:

  A scalar character of the pipeline name.

- names:

  Names of the targets to run or check. Set to `NULL` to check/run all
  the targets (default). The object supplied to `names` should be a
  `tidyselect` expression like
  [`any_of()`](https://tidyselect.r-lib.org/reference/all_of.html) or
  [`starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html)
  from `tidyselect` itself, or
  [`tar_described_as()`](https://docs.ropensci.org/targets/reference/tar_described_as.html)
  to select target names based on their descriptions.

- shortcut:

  Logical of length 1, how to interpret the `names` argument. If
  `shortcut` is `FALSE` (default) then the function checks all targets
  upstream of `names` as far back as the dependency graph goes.
  `shortcut = TRUE` increases speed if there are a lot of up-to-date
  targets, but it assumes all the dependencies are up to date, so please
  use with caution. It relies on stored metadata for information about
  upstream dependencies. `shortcut = TRUE` only works if you set
  `names`.

- reporter:

  A scalar character of the reporter type. By default, `"silent"`. See
  [`targets::tar_make()`](https://docs.ropensci.org/targets/reference/tar_make.html)
  for more options.

- seconds_meta_append:

  Positive numeric of length 1 with the minimum number of seconds
  between saves to the local metadata and progress files in the data
  store. his is an aggressive optimization setting not recommended for
  most users: higher values generally make the pipeline run faster, but
  unsaved work (in the event of a crash) is not up to date. When the
  pipeline ends, all the metadata and progress data is saved
  immediately, regardless of `seconds_meta_append`.

  When the pipeline is just skipping targets, the actual interval
  between saves is `max(1, seconds_meta_append)` to reduce overhead.

- seconds_meta_upload:

  Positive numeric of length 1 with the minimum number of seconds
  between uploads of the metadata and progress data to the cloud (see
  <https://books.ropensci.org/targets/cloud-storage.html>). Higher
  values generally make the pipeline run faster, but unsaved work (in
  the event of a crash) may not be backed up to the cloud. When the
  pipeline ends, all the metadata and progress data is uploaded
  immediately, regardless of `seconds_meta_upload`.

- seconds_reporter:

  Deprecated on 2025-03-31 (`targets` version 1.10.1.9010).

- seconds_interval:

  Deprecated on 2023-08-24 (targets version 1.2.2.9001). Use
  `seconds_meta_append` and `seconds_meta_upload` instead.

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

- garbage_collection:

  Deprecated. Use the `garbage_collection` argument of
  [`tar_option_set()`](https://docs.ropensci.org/targets/reference/tar_option_set.html)
  instead to run garbage collection at regular intervals in a pipeline,
  or use the argument of the same name in
  [`tar_target()`](https://docs.ropensci.org/targets/reference/tar_target.html)
  to activate garbage collection for a specific target.

- use_crew:

  Logical of length 1, whether to use `crew` if the `controller` option
  is set in
  [`tar_option_set()`](https://docs.ropensci.org/targets/reference/tar_option_set.html)
  in the target script (`_targets.R`). See
  <https://books.ropensci.org/targets/crew.html> for details.

- terminate_controller:

  Logical of length 1. For a `crew`-integrated pipeline, whether to
  terminate the controller after stopping or finishing the pipeline.
  This should almost always be set to `TRUE`, but `FALSE` combined with
  `callr_function = NULL` will allow you to get the running controller
  using `tar_option_get("controller")` for debugging purposes. For
  example, `tar_option_get("controller")$summary()` produces a
  worker-by-worker summary of the work assigned and completed,
  `tar_option_get("controller")$queue` is the list of unresolved tasks,
  and `tar_option_get("controller")$results` is the list of tasks that
  completed but were not collected with `pop()`. You can manually
  terminate the controller with `tar_option_get("controller")$summary()`
  to close down the dispatcher and worker processes.

- as_job:

  `TRUE` to run as an RStudio IDE / Posit Workbench job, if running on
  RStudio IDE / Posit Workbench. `FALSE` to run as a `callr` process in
  the main R session (depending on the `callr_function` argument). If
  `as_job` is `TRUE`, then the `rstudioapi` package must be installed.

## Value

`NULL` except if `callr_function = callr::r_bg()`, in which case a
handle to the `callr` background process is returned. Either way, the
value is invisibly returned.
