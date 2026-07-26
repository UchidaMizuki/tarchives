# Get a target's value from archive storage, building first if needed

**\[experimental\]**

## Usage

``` r
tar_get_archive(
  name,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  reporter = "silent",
  callr_function = callr::r,
  callr_arguments = targets::tar_callr_args_default(callr_function, reporter),
  envir = parent.frame(),
  store = targets::tar_config_get("store")
)

tar_get_archive_raw(
  name,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  reporter = "silent",
  callr_function = callr::r,
  callr_arguments = targets::tar_callr_args_default(callr_function, reporter),
  envir = parent.frame(),
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

- reporter:

  Character of length 1, name of the reporter to user. Controls how
  messages are printed as targets run in the pipeline.

  The default value of `reporter` is the value returned by
  `tar_config_get("reporter_make")`. The default of
  `tar_config_get("reporter_make")` is `"terse"` if the calling R
  session is either:

        1. Non-interactive (`interactive()` returns `FALSE`), or
        2. Inside a literate programming document
          (the `knitr.in.progress` global option is `TRUE`).

  Otherwise, the default is `"balanced"`. You can always set the
  reporter manually. Choices:

  - `"balanced"`: a reporter that balances efficiency with informative
    detail. Uses a `cli` progress bar instead of printing messages for
    individual dynamic branches. To the right of the progress bar is a
    text string like "22.6s, 4510+, 124-" (22.6 seconds elapsed, 4510
    targets completed successfully so far, 124 targets skipped so far).

    For best results with the balanced reporter, you may need to adjust
    your `cli` settings. See global options `cli.num_colors` and
    `cli.dynamic` at <https://cli.r-lib.org/reference/cli-config.html>.
    On that page is also the `CLI_TICK_TIME` environment variable which
    controls the time delay between progress bar updates. If the delay
    is too low, then overhead from printing to the console may slow down
    the pipeline.

  - `"terse"`: like the `"balanced"` reporter, but without a progress
    bar.

  - `"silent"`: print nothing.

  - `"timestamp"`: same as the `"verbose"` reporter except that each
    message begins with a time stamp.

  - `"verbose"`: print messages for individual targets as they dispatch
    or complete. Each individual target-specific time (e.g. "3.487
    seconds") is strictly the elapsed runtime of the target and does not
    include steps like data retrieval and output storage.

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

  An environment used to resolve `package`, so that a package currently
  loaded with
  [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
  (e.g. during interactive package development) is resolved to its
  source directory instead of its installed one. Defaults to the calling
  environment.

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

Combines
[`tar_make_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_make_archive.md)
and
[`tar_read_archive_raw()`](https://uchidamizuki.github.io/tarchives/reference/tar_read_archive.md):
builds `name` unless it has already been confirmed up to date for the
installed version of `package` earlier in the same R session, then reads
it.

`tar_get_archive()` captures `name` with non-standard evaluation,
whereas `tar_get_archive_raw()` takes it as a character string.

Unlike
[`tar_read_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_read_archive.md)
– which, mirroring
[`targets::tar_read()`](https://docs.ropensci.org/targets/reference/tar_read.html),
only ever reads and errors if the store doesn't exist yet –
`tar_get_archive()` is for callers that just want the current data
without separately calling
[`tar_make_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_make_archive.md)
themselves first. The build (when needed) runs in a `callr` subprocess
by default, same as
[`tar_make_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_make_archive.md)
itself, so a crash or state leak (loaded packages, changed
[`options()`](https://rdrr.io/r/base/options.html)) during the build
can't take down the caller's own R session. This only runs at most once
per `name` per installed version of `package` per session, so that
isolation is cheap to keep; pass `callr_function = NULL` yourself only
if you understand and accept running the build in-process.

## Examples

``` r
# \donttest{
withr::with_envvar(
  c(R_USER_CACHE_DIR = tempfile()),
  tar_get_archive(model, package = "tarchives", pipeline = "example-model")
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
