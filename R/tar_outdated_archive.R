#' Check whichi archived targets are outdated
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_outdated
#'
#' @inherit targets::tar_outdated return
#'
#' @export
tar_outdated_archive <- function(
    package,
    pipeline,
    names = NULL,
    shortcut = targets::tar_config_get("shortcut"),
    branches = FALSE,
    targets_only = TRUE,
    reporter = targets::tar_config_get("reporter_outdated"),
    seconds_reporter = targets::tar_config_get("seconds_reporter"),
    seconds_interval = targets::tar_config_get("seconds_interval"),
    callr_function = callr::r,
    callr_arguments = targets::tar_callr_args_default(callr_function, reporter),
    envir = parent.frame(),
    script = targets::tar_config_get("script"),
    store = targets::tar_config_get("store")
) {
  script <- tar_archive_script(
    package = package,
    pipeline = pipeline,
    script = script,
    envir = envir
  )
  store <- tar_archive_store(
    package = package,
    pipeline = pipeline,
    store = store
  )

  targets::tar_outdated(
    names = {{ names }},
    shortcut = shortcut,
    branches = branches,
    targets_only = targets_only,
    reporter = reporter,
    seconds_reporter = seconds_reporter,
    seconds_interval = seconds_interval,
    callr_function = callr_function,
    callr_arguments = callr_arguments,
    envir = envir,
    script = script,
    store = store
  )
}
