#' List the archived pipelines in a package
#'
#' Returns the names of the pipelines bundled in a package's
#' `inst/tarchives` directory. Use it to discover which pipelines are
#' available before running them with [tar_make_archive()] or inspecting their
#' targets with [tar_manifest_archive()].
#'
#' @param package A scalar character of the package name.
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
  script = targets::tar_config_get("script")
) {
  check_string(package, allow_empty = FALSE)
  check_string(script, allow_empty = FALSE)
  if (!nzchar(system.file(package = package))) {
    cli::cli_abort(c(
      "Can't find package {.pkg {package}}.",
      i = "Is it installed?"
    ))
  }
  root <- system.file("tarchives", package = package)
  if (!nzchar(root)) {
    return(character())
  }
  dirs <- fs::dir_ls(root, type = "directory")
  dirs <- dirs[fs::file_exists(fs::path(dirs, script))]
  sort(as.character(fs::path_file(dirs)))
}
