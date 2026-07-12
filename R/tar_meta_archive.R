#' Read metadata from archive storage
#'
#' tarchives version of [targets::tar_meta()]. Returns the metadata of an
#' archived pipeline's store.
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_meta
#'
#' @inherit targets::tar_meta return
#'
#' @examples
#' \donttest{
#' withr::with_envvar(
#'   c(R_USER_CACHE_DIR = tempfile()),
#'   {
#'     tar_make_archive(package = "tarchives", pipeline = "example-model")
#'     tar_meta_archive(package = "tarchives", pipeline = "example-model")
#'   }
#' )
#' }
#'
#' @export
tar_meta_archive <- function(
  package,
  pipeline,
  names = NULL,
  fields = NULL,
  targets_only = FALSE,
  complete_only = FALSE,
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
  targets::tar_meta(
    names = {{ names }},
    fields = {{ fields }},
    targets_only = targets_only,
    complete_only = complete_only,
    store = store
  )
}
