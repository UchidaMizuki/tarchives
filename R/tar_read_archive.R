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

#' @rdname tar_read_archive
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
  tar_archive(
    targets::tar_read_raw,
    package = package,
    pipeline = pipeline,
    store = store
  )(
    name = name,
    branches = branches,
    meta = meta
  )
}

tar_read_archive_impl <- function(f, args) {
  function(meta, ...) {
    meta <- meta %||% targets::tar_meta(
      store = args$store
    )
    rlang::exec(f, !!!args,
                meta = meta, ...)
  }
}
