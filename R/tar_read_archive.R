#' Read a target's value from archive storage
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_read
#'
#' @inherit targets::tar_read return
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
