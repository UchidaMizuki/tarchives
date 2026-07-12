#' Destroy an archived pipeline's storage
#'
#' tarchives version of [targets::tar_destroy()]. Removes the cached `targets`
#' store of an archived pipeline from the R user cache directory
#' (`tools::R_user_dir("tarchives", "cache")`).
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_destroy
#'
#' @inherit targets::tar_destroy return
#'
#' @examples
#' \donttest{
#' withr::with_envvar(
#'   c(R_USER_CACHE_DIR = tempfile()),
#'   {
#'     tar_make_archive(package = "tarchives", pipeline = "example-model")
#'     tar_destroy_archive(package = "tarchives", pipeline = "example-model", ask = FALSE)
#'   }
#' )
#' }
#'
#' @export
tar_destroy_archive <- function(
  package,
  pipeline,
  destroy = "all",
  batch_size = 1000L,
  verbose = TRUE,
  ask = NULL,
  store = targets::tar_config_get("store")
) {
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  store <- tar_archive_store(
    package = package,
    pipeline = pipeline,
    store = store
  )
  targets::tar_destroy(
    destroy = destroy,
    batch_size = batch_size,
    verbose = verbose,
    ask = ask,
    store = store
  )
}
