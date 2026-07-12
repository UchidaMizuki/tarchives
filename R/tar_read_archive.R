#' Read a target's value from archive storage
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_read
#'
#' @inherit targets::tar_read return
#'
#' @examples
#' \donttest{
#' withr::with_envvar(
#'   c(R_USER_CACHE_DIR = tempfile()),
#'   {
#'     tar_make_archive(package = "tarchives", pipeline = "example-model")
#'     tar_read_archive(model, package = "tarchives", pipeline = "example-model")
#'   }
#' )
#' }
#'
#' @export
tar_read_archive <- function(
  name,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  store = targets::tar_config_get("store")
) {
  name <- targets::tar_deparse_language(substitute(name))
  tar_read_archive_raw(
    name = name,
    package = package,
    pipeline = pipeline,
    branches = branches,
    meta = meta,
    store = store
  )
}

#' @rdname tar_read_archive
#'
#' @details
#' `tar_read_archive()` captures `name` with non-standard evaluation, whereas
#' `tar_read_archive_raw()` takes it as a character string.
#'
#' @export
tar_read_archive_raw <- function(
  name,
  package,
  pipeline,
  branches = NULL,
  meta = NULL,
  store = targets::tar_config_get("store")
) {
  check_string(name, allow_empty = FALSE)
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
  targets::tar_read_raw(
    name = name,
    branches = branches,
    meta = meta,
    store = store
  )
}
