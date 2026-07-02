#' List the archived pipelines in a package
#'
#' Returns the names of the pipelines bundled in a package's
#' `inst/tarchives` directory. Use it to discover which pipelines are
#' available before running them with [tar_make_archive()] or inspecting their
#' targets with [tar_manifest_archive()].
#'
#' @param package A scalar character of the package name.
#' @param envir An environment used to resolve `package`, so that a package
#' currently loaded with `pkgload::load_all()` (e.g. during interactive
#' package development) is resolved to its source directory instead of its
#' installed one. Defaults to the calling environment.
#' @inheritParams targets::tar_make
#'
#' @return A character vector of pipeline names. A pipeline is a directory in
#' `inst/tarchives` that contains a target script file (`script`), so the
#' shared `R/` helper directory is not included.
#'
#' @seealso [tar_manifest_archive()] to list the targets within a pipeline.
#'
#' @export
tar_archive_pipelines <- function(
  package,
  envir = parent.frame(),
  script = targets::tar_config_get("script")
) {
  check_string(package, allow_empty = FALSE)
  check_string(script, allow_empty = FALSE)
  if (!nzchar(eval_system_file(package = package, envir = envir))) {
    cli::cli_abort(c(
      "Can't find package {.pkg {package}}.",
      i = "Is it installed?"
    ))
  }
  root <- eval_system_file("tarchives", package = package, envir = envir)
  if (!nzchar(root)) {
    return(character())
  }
  dirs <- fs::dir_ls(root, type = "directory")
  dirs <- dirs[fs::file_exists(fs::path(dirs, script))]
  sort(as.character(fs::path_file(dirs)))
}
