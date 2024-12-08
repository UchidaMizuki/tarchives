#' @rdname tar_read_archive
#' @export
tar_read_archive_raw <- function(
    name,
    package,
    pipeline,
    branches = NULL,
    meta = NULL,
    store = targets::tar_config_get("store")
) {
  store <- store_dir(
    package = package,
    pipeline = pipeline,
    store = store
  )
  meta <- meta %||% targets::tar_meta(
    store = store
  )
  targets::tar_read_raw(
    name = name,
    branches = branches,
    meta = meta,
    store = store
  )
}
