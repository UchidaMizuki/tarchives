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
#'
#' @details
#' `tar_check_archive_name()` reads the pipeline's target script in a `callr`
#' subprocess, so anything the script does -- such as calling
#' [targets::tar_option_set()] or attaching packages -- can't affect the
#' caller's R session. This makes it safe to call from a function used in a
#' user's own target script. The target names are cached for the rest of the
#' session per version of `package`, so only the first check of each pipeline
#' pays the subprocess startup cost. Checks run by the target script itself
#' (e.g. when one data package's pipeline uses another's targets) are skipped
#' while its names are read, so the cost doesn't grow with the nesting depth.
#'
#' @export
tar_check_archive_name <- function(
  name,
  package,
  pipeline,
  envir = parent.frame(),
  arg_nm = rlang::caller_arg(name),
  error_call = rlang::caller_env()
) {
  # Inside the subprocess that reads another pipeline's target names, nested
  # checks are skipped: only the names are needed there, and checking would
  # start yet another subprocess per level of nesting.
  if (nzchar(Sys.getenv("TARCHIVES_READING_NAMES"))) {
    return(name)
  }
  names <- archive_target_names(
    package = package,
    pipeline = pipeline,
    envir = envir
  )
  rlang::arg_match0(
    name,
    names,
    arg_nm = arg_nm,
    error_call = error_call
  )
}

# Session-only cache of the target names of each package/pipeline, keyed like
# `archive_build_cache`, so only the first check of a pipeline pays the
# subprocess startup cost of `tar_manifest_archive()`. The package version the
# names were read for is stored with them, so a version bump invalidates them.
archive_names_cache <- rlang::new_environment()

archive_target_names <- function(package, pipeline, envir) {
  version <- as.character(utils::packageVersion(package))
  pipelines <- rlang::env_get(archive_names_cache, package, default = list())
  if (!identical(pipelines[[pipeline]]$version, version)) {
    names <- withr::with_envvar(
      c(TARCHIVES_READING_NAMES = "true"),
      tar_manifest_archive(
        package = package,
        pipeline = pipeline,
        envir = envir
      )$name
    )
    pipelines[[pipeline]] <- list(version = version, names = names)
    rlang::env_poke(archive_names_cache, package, pipelines)
  }
  pipelines[[pipeline]]$names
}
