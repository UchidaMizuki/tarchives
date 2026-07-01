#' List the targets of an archived pipeline
#'
#' tarchives version of [targets::tar_manifest()]. Returns a data frame of the
#' targets defined in an archived pipeline's target script file.
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_manifest
#'
#' @inherit targets::tar_manifest return
#'
#' @seealso [tar_archive_pipelines()] to list the pipelines in a package.
#'
#' @export
tar_manifest_archive <- function(
  package,
  pipeline,
  names = NULL,
  fields = NULL,
  drop_missing = TRUE,
  callr_function = callr::r,
  callr_arguments = targets::tar_callr_args_default(callr_function),
  envir = parent.frame(),
  script = targets::tar_config_get("script")
) {
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  script <- tar_archive_script(
    package = package,
    pipeline = pipeline,
    script = script
  )
  with_dir_archive(
    package = package,
    pipeline = pipeline,
    targets::tar_manifest(
      names = {{ names }},
      fields = {{ fields }},
      drop_missing = drop_missing,
      callr_function = callr_function,
      callr_arguments = callr_arguments,
      envir = envir,
      script = script
    )
  )
}
