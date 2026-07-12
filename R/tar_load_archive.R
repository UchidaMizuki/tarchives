#' Load a target's value from archive storage
#'
#' tarchives version of [targets::tar_load()]. Reads one or more targets from
#' an archived pipeline's store and assigns them into an environment.
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_load
#'
#' @inherit targets::tar_load return
#'
#' @examples
#' \donttest{
#' withr::with_envvar(
#'   c(R_USER_CACHE_DIR = tempfile()),
#'   {
#'     tar_make_archive(package = "tarchives", pipeline = "example-model")
#'     tar_load_archive(model, package = "tarchives", pipeline = "example-model")
#'     model
#'   }
#' )
#' }
#'
#' @export
tar_load_archive <- function(
  names,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  strict = TRUE,
  silent = FALSE,
  envir = parent.frame(),
  store = targets::tar_config_get("store")
) {
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  store <- tar_archive_store(
    package = package,
    pipeline = pipeline,
    store = store
  )
  check_archive_store_exists(store, package = package, pipeline = pipeline)
  meta <- meta %||%
    targets::tar_meta(
      store = store
    )
  targets::tar_load(
    names = {{ names }},
    branches = branches,
    meta = meta,
    strict = strict,
    silent = silent,
    envir = envir,
    store = store
  )
}
