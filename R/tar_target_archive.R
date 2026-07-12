#' Declare a target to read an archive
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @param name_archive Symbol, name of the archived target. If `NULL`, the
#' name of the target is used. By default, `NULL`.
#' @param ... Arguments to pass to [tar_make_archive()] or
#' [tar_read_archive_raw()].
#' @inheritParams targets::tar_target
#'
#' @inherit targets::tar_target return
#'
#' @examples
#' tar_target_archive(
#'   model,
#'   package = "tarchives",
#'   pipeline = "example-model"
#' )
#'
#' @export
tar_target_archive <- function(
  name,
  package,
  pipeline,
  name_archive = NULL,
  ...,
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
  name_archive <- targets::tar_deparse_language(substitute(name_archive)) %||%
    name
  tar_target_archive_raw(
    name = name,
    package = package,
    pipeline = pipeline,
    name_archive = name_archive,
    ...,
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
#' @details
#' `tar_target_archive()` captures `name` and `name_archive` with non-standard
#' evaluation, whereas `tar_target_archive_raw()` takes them as character
#' strings.
#'
#' The archive is built (if outdated) and read when the target runs, not when
#' the target script is sourced, so inspecting the pipeline with
#' [targets::tar_manifest()] or [targets::tar_visnetwork()] does not trigger a
#' build. The target tracks the installed version of `package`, so it reruns
#' and refreshes the data when a new version of the package providing the
#' archive is installed, and is skipped otherwise. Downstream targets still
#' only rebuild when the value actually changes.
#'
#' @export
tar_target_archive_raw <- function(
  name,
  package,
  pipeline,
  name_archive = name,
  ...,
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
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  args <- rlang::list2(...)

  # Build the upstream archive (if outdated) and read the target as part of the
  # target's *command*, so the work happens at build time inside the pipeline's
  # own process. Doing it here, rather than when `tar_target_archive()` is
  # called, avoids triggering builds whenever `_targets.R` is merely sourced --
  # e.g. by `tar_manifest()`, `tar_network()`, or `tar_visnetwork()`.
  command <- rlang::call2(
    "{",
    rlang::call2(
      "tar_make_archive",
      package = package,
      pipeline = pipeline,
      names = name_archive,
      !!!args[names(args) %in% rlang::fn_fmls_names(targets::tar_make)],
      .ns = "tarchives"
    ),
    rlang::call2(
      "tar_read_archive_raw",
      name = name_archive,
      package = package,
      pipeline = pipeline,
      !!!args[names(args) %in% rlang::fn_fmls_names(tar_read_archive_raw)],
      .ns = "tarchives"
    )
  )

  # Fold the installed package version into the string that `targets` hashes
  # for up-to-dateness (the `string` argument is the mechanism `targets`
  # provides for this). The target then reruns -- rebuilding and rereading the
  # data -- when a new version of the package providing the archive is
  # installed, matching the "update the data as versions are updated" model,
  # and is skipped otherwise.
  string <- string %||%
    paste0(
      paste(deparse(command), collapse = "\n"),
      utils::packageVersion(package)
    )
  targets::tar_target_raw(
    name = name,
    command = command,
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
