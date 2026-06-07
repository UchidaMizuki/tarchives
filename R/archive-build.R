# Session-scoped cache of per-pipeline `tar_outdated()` results.
#
# Building a target list re-runs `tar_target_archive()` for every declared
# target, and `targets` rebuilds the list on every operation (tar_make(),
# tar_outdated(), tar_manifest(), ...). Without memoisation, a pipeline
# referenced by N targets would launch N `tar_outdated()` subprocesses, each
# loading `targets` and re-evaluating the whole archived pipeline.
#
# The cache key includes the modification times of the pipeline script and its
# metadata, so it invalidates automatically when the data package is updated or
# when the store is rebuilt -- preserving the "detect changes and rebuild"
# behaviour while collapsing the redundant checks.
the <- new.env(parent = emptyenv())
the$outdated <- new.env(parent = emptyenv())

archive_mtime <- function(path) {
  if (fs::file_exists(path)) {
    as.numeric(fs::file_info(path)$modification_time)
  } else {
    NA_real_
  }
}

archive_outdated <- function(package, pipeline, store, args = list()) {
  script <- tar_archive_script(package = package, pipeline = pipeline)
  key <- paste(
    package,
    pipeline,
    store,
    archive_mtime(script),
    archive_mtime(fs::path(store, "meta", "meta")),
    sep = ""
  )
  hit <- the$outdated[[key]]
  if (!is.null(hit)) {
    return(hit)
  }
  tar_outdated_archive <- tar_archive(
    targets::tar_outdated,
    package = package,
    pipeline = pipeline
  )
  outdated <- rlang::exec(
    tar_outdated_archive,
    !!!args[names(args) %in% rlang::fn_fmls_names(targets::tar_outdated)]
  )
  the$outdated[[key]] <- outdated
  outdated
}

ensure_archive_built <- function(
  package,
  pipeline,
  names,
  store,
  args = list()
) {
  build <- intersect(
    names,
    archive_outdated(
      package = package,
      pipeline = pipeline,
      store = store,
      args = args
    )
  )
  if (length(build) > 0L) {
    rlang::exec(
      tarchives::tar_make_archive,
      package = package,
      pipeline = pipeline,
      names = build,
      !!!args[names(args) %in% rlang::fn_fmls_names(targets::tar_make)]
    )
  }
  invisible(build)
}
