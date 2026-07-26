#' Get a target's value from archive storage, building first if needed
#'
#' `r lifecycle::badge('experimental')`
#'
#' Combines [tar_make_archive()] and [tar_read_archive_raw()]: builds `name`
#' unless it has already been confirmed up to date for the installed version
#' of `package` earlier in the same R session, then reads it.
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_read
#' @inheritParams targets::tar_make
#' @param envir An environment used to resolve `package`, so that a package
#' currently loaded with `pkgload::load_all()` (e.g. during interactive
#' package development) is resolved to its source directory instead of its
#' installed one. Defaults to the calling environment.
#'
#' @inherit targets::tar_read return
#'
#' @examples
#' \donttest{
#' withr::with_envvar(
#'   c(R_USER_CACHE_DIR = tempfile()),
#'   tar_get_archive(model, package = "tarchives", pipeline = "example-model")
#' )
#' }
#'
#' @export
tar_get_archive <- function(
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
) {
  name <- targets::tar_deparse_language(substitute(name))
  tar_get_archive_raw(
    name = name,
    package = package,
    pipeline = pipeline,
    branches = branches,
    meta = meta,
    reporter = reporter,
    callr_function = callr_function,
    callr_arguments = callr_arguments,
    envir = envir,
    store = store
  )
}

#' @rdname tar_get_archive
#'
#' @details
#' `tar_get_archive()` captures `name` with non-standard evaluation, whereas
#' `tar_get_archive_raw()` takes it as a character string.
#'
#' Unlike [tar_read_archive()] -- which, mirroring `targets::tar_read()`,
#' only ever reads and errors if the store doesn't exist yet --
#' `tar_get_archive()` is for callers that just want the current data without
#' separately calling [tar_make_archive()] themselves first. The build (when
#' needed) runs in a `callr` subprocess by default, same as
#' [tar_make_archive()] itself, so a crash or state leak (loaded packages,
#' changed `options()`) during the build can't take down the caller's own R
#' session. This only runs at most once per `name` per installed version of
#' `package` per session, so that isolation is cheap to keep; pass
#' `callr_function = NULL` yourself only if you understand and accept running
#' the build in-process.
#'
#' @export
tar_get_archive_raw <- function(
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
) {
  check_string(name, allow_empty = FALSE)
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  if (!archive_built(package = package, pipeline = pipeline, name = name)) {
    tar_make_archive(
      package = package,
      pipeline = pipeline,
      names = name,
      reporter = reporter,
      callr_function = callr_function,
      callr_arguments = callr_arguments,
      envir = envir,
      store = store
    )
    archive_mark_built(package = package, pipeline = pipeline, name = name)
  }
  tar_read_archive_raw(
    name = name,
    package = package,
    pipeline = pipeline,
    branches = branches,
    meta = meta,
    store = store
  )
}
