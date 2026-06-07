#' Read a target's value from archive storage
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @param make A scalar logical. If `TRUE`, the target is built with
#' [tar_make_archive()] before reading when it is out of date. This lets you
#' expose archived data through a plain accessor function without requiring
#' callers to know about 'targets'. By default, `FALSE`.
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
  make = FALSE,
  store = targets::tar_config_get("store")
) {
  name <- targets::tar_deparse_language(substitute(name))
  tar_read_archive_raw(
    name = name,
    package = package,
    pipeline = pipeline,
    branches = branches,
    meta = meta,
    make = make,
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
  make = FALSE,
  store = targets::tar_config_get("store")
) {
  check_string(name, allow_empty = FALSE)
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  check_bool(make)
  store <- tar_archive_store(
    package = package,
    pipeline = pipeline,
    store = store
  )
  if (make) {
    ensure_archive_built(
      package = package,
      pipeline = pipeline,
      names = name,
      store = store
    )
  }
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
