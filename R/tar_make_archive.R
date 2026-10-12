#' Run an archived pipeline of targets
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @param reporter A scalar character of the reporter type. By default,
#' `"silent"`. See [targets::tar_make()] for more options.
#' @inheritParams targets::tar_make
#'
#' @inherit targets::tar_make return
#'
#' @examples
#' \donttest{
#' withr::with_envvar(
#'   c(R_USER_CACHE_DIR = tempfile()),
#'   tar_make_archive(package = "tarchives", pipeline = "example-model")
#' )
#' }
#'
#' @export
tar_make_archive <- function(
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
) {
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  script <- tar_archive_script(
    package = package,
    pipeline = pipeline,
    envir = envir,
    script = script
  )
  store <- tar_archive_store(
    package = package,
    pipeline = pipeline,
    store = store
  )
  call <- current_env()
  local_archive_lock(store = store, package = package, pipeline = pipeline)
  with_dir_archive(
    package = package,
    pipeline = pipeline,
    envir = envir,
    with_archive_build_error(
      package = package,
      pipeline = pipeline,
      call = call,
      targets::tar_make(
        names = {{ names }},
        shortcut = shortcut,
        reporter = reporter,
        seconds_meta_append = seconds_meta_append,
        seconds_meta_upload = seconds_meta_upload,
        seconds_reporter = seconds_reporter,
        seconds_interval = seconds_interval,
        callr_function = callr_function,
        callr_arguments = callr_arguments,
        envir = envir,
        script = script,
        store = store,
        garbage_collection = garbage_collection,
        use_crew = use_crew,
        terminate_controller = terminate_controller,
        as_job = as_job
      )
    )
  )
}

# Hold an exclusive lock on the store until the calling function exits.
# `targets` doesn't support concurrent `tar_make()` calls on one store, and the
# store in the user cache is shared by every R process, so two processes
# requesting the same archive at once (e.g. parallel workers each calling
# `tar_get_archive()`) would otherwise build it simultaneously. The second
# caller waits, then finds the store up to date. With `as_job = TRUE` the lock
# is released once the job starts, not when it finishes.
local_archive_lock <- function(store, package, pipeline, frame = caller_env()) {
  path <- paste0(store, ".lock")
  fs::dir_create(fs::path_dir(path))
  lock <- filelock::lock(path, timeout = 0)
  if (is.null(lock)) {
    cli::cli_inform(
      "Waiting for another R process to finish building pipeline \\
      {.val {pipeline}} of package {.pkg {package}}."
    )
    lock <- filelock::lock(path)
  }
  withr::defer(filelock::unlock(lock), envir = frame)
  invisible(lock)
}

# Rethrow a failed build with the package and pipeline that failed, since the
# error usually reaches end users through a downstream package's function
# rather than a direct `tar_make_archive()` call. When the cause is a missing
# package, point at the usual reason: packages needed only to build a pipeline
# are often in the providing package's `Suggests`, which aren't installed by
# default.
#
# An exiting handler (rather than a calling one) so that errors `targets`
# catches and handles internally are left alone.
with_archive_build_error <- function(package, pipeline, call, code) {
  tryCatch(code, error = function(cnd) {
    info <- NULL
    if (inherits(cnd, "packageNotFoundError")) {
      info <- c(
        i = "The pipeline needs a package that isn't installed.",
        i = "Packages needed only to build a pipeline are often suggested \\
        dependencies of {.pkg {package}}, which aren't installed by default. \\
        To install them, run \\
        {.run install.packages(\"{package}\", dependencies = TRUE)}."
      )
    }
    cli::cli_abort(
      c(
        "Can't build pipeline {.val {pipeline}} of package {.pkg {package}}.",
        info
      ),
      parent = cnd,
      class = "tarchives_error_build",
      call = call
    )
  })
}
