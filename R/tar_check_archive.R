#' Check a pipeline or target name
#'
#' Validates `pipeline` against the pipelines bundled in `package` (see
#' [tar_archive_pipelines()]), or `name` against the targets defined in a
#' pipeline (see [tar_manifest_archive()]). Errors with a "did you mean"
#' suggestion when the value doesn't match, so callers don't have to
#' reimplement this check themselves.
#'
#' @param pipeline,name A scalar character of the pipeline or target name to
#' check.
#' @param package A scalar character of the package name.
#' @param envir An environment used to resolve `package`, so that a package
#' currently loaded with `pkgload::load_all()` (e.g. during interactive
#' package development) is resolved to its source directory instead of its
#' installed one. Defaults to the calling environment.
#' @param arg_nm,error_call Passed to [rlang::arg_match0()] to attribute the
#' error to the correct argument and call.
#'
#' @return `pipeline` or `name`, invisibly, if valid. Otherwise, throws an
#' error.
#'
#' @seealso [tar_archive_pipelines()] to list the pipelines in a package, and
#' [tar_manifest_archive()] to list the targets within a pipeline.
#'
#' @examples
#' tar_check_archive_pipeline("example-model", package = "tarchives")
#'
#' \donttest{
#' withr::with_envvar(
#'   c(R_USER_CACHE_DIR = tempfile()),
#'   tar_check_archive_name(
#'     "data",
#'     package = "tarchives",
#'     pipeline = "example-model"
#'   )
#' )
#' }
#'
#' @export
tar_check_archive_pipeline <- function(
  pipeline,
  package,
  envir = parent.frame(),
  arg_nm = rlang::caller_arg(pipeline),
  error_call = rlang::caller_env()
) {
  pipelines <- tar_archive_pipelines(package = package, envir = envir)
  rlang::arg_match0(
    pipeline,
    pipelines,
    arg_nm = arg_nm,
    error_call = error_call
  )
}

#' @rdname tar_check_archive_pipeline
#' @export
tar_check_archive_name <- function(
  name,
  package,
  pipeline,
  envir = parent.frame(),
  arg_nm = rlang::caller_arg(name),
  error_call = rlang::caller_env()
) {
  names <- tar_manifest_archive(
    package = package,
    pipeline = pipeline,
    envir = envir,
    callr_function = NULL
  )$name
  rlang::arg_match0(
    name,
    names,
    arg_nm = arg_nm,
    error_call = error_call
  )
}
