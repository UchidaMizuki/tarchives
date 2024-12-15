#' Declare a target to read an archive.
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @param ... Arguments to pass to [targets::tar_make()] etc.
#' @inheritParams targets::tar_target
#'
#' @inherit targets::tar_target return
#'
#' @export
tar_target_archive <- function(
    name,
    package,
    pipeline, ...,
    pattern = NULL,
    packages = targets::tar_option_get("packages"),
    library = targets::tar_option_get("library"),
    deps = NULL,
    string = NULL,
    format = targets::tar_option_get("format"),
    repository = targets::tar_option_get("repository"),
    iteration = targets::tar_option_get("iteration"),
    error = targets::tar_option_get("error"),
    memory = targets::tar_option_get("memory"),
    garbage_collection = isTRUE(targets::tar_option_get("garbage_collection")),
    deployment = targets::tar_option_get("deployment"),
    priority = targets::tar_option_get("priority"),
    resources = targets::tar_option_get("resources"),
    storage = targets::tar_option_get("storage"),
    retrieval = targets::tar_option_get("retrieval"),
    cue = targets::tar_option_get("cue"),
    description = targets::tar_option_get("description")
) {
  name <- targets::tar_deparse_language(substitute(name))

  tar_target_archive_raw(
    name = name,
    package = package,
    pipeline = pipeline, ...,
    pattern = pattern,
    packages = packages,
    library = library,
    deps = deps,
    string = string,
    format = format,
    repository = repository,
    iteration = iteration,
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = deployment,
    priority = priority,
    resources = resources,
    storage = storage,
    retrieval = retrieval,
    cue = cue,
    description = description
  )
}

#' @rdname tar_target_archive
#'
#' @export
tar_target_archive_raw <- function(
    name,
    package,
    pipeline, ...,
    pattern = NULL,
    packages = targets::tar_option_get("packages"),
    library = targets::tar_option_get("library"),
    deps = NULL,
    string = NULL,
    format = targets::tar_option_get("format"),
    repository = targets::tar_option_get("repository"),
    iteration = targets::tar_option_get("iteration"),
    error = targets::tar_option_get("error"),
    memory = targets::tar_option_get("memory"),
    garbage_collection = isTRUE(targets::tar_option_get("garbage_collection")),
    deployment = targets::tar_option_get("deployment"),
    priority = targets::tar_option_get("priority"),
    resources = targets::tar_option_get("resources"),
    storage = targets::tar_option_get("storage"),
    retrieval = targets::tar_option_get("retrieval"),
    cue = targets::tar_option_get("cue"),
    description = targets::tar_option_get("description")
) {
  tar_archive(
    targets::tar_target_raw,
    package = package,
    pipeline = pipeline
  )(
    name = name,
    pattern = pattern,
    packages = packages,
    library = library,
    deps = deps,
    string = string,
    format = format,
    repository = repository,
    iteration = iteration,
    error = error,
    memory = memory,
    garbage_collection = garbage_collection,
    deployment = deployment,
    priority = priority,
    resources = resources,
    storage = storage,
    retrieval = retrieval,
    cue = cue,
    description = description
  )
}

tar_target_archive_impl <- function(f, args, package, pipeline, envir, script, store) {
  tar_outdated_archive <- tar_archive(
    targets::tar_outdated,
    package = package,
    pipeline = pipeline
  )

  function(name, cue, ...) {
    if (name %in% tar_outdated_archive(names = name)) {
      cue$mode <- "always"

      tar_make_archive(
        package = package,
        pipeline = pipeline,
        names = name,
        envir = envir,
        script = script,
        store = store,
        !!!args
      )
    }

    args <- rlang::list2(...)

    fmls_names_tar_read_archive_raw <- rlang::fn_fmls_names(tar_read_archive_raw)
    args_tar_read_archive_raw <- args[names(args) %in% fmls_names_tar_read_archive_raw]
    command <- rlang::call2(
      "tar_read_archive_raw",
      name = name,
      package = package,
      pipeline = pipeline,
      store = store,
      !!!args_tar_read_archive_raw
    )

    fmls_names <- rlang::fn_fmls_names(f)
    args <- args[names(args) %in% fmls_names]
    rlang::exec(
      f,
      name = name,
      command = command,
      cue = cue,
      !!!args
    )
  }
}
