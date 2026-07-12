#' Run archived R scripts
#'
#' @param package A scalar character of the package name.
#' @inheritParams targets::tar_source
#'
#' @inherit targets::tar_source return
#'
#' @examples
#' tar_source_archive(package = "tarchives")
#'
#' @export
tar_source_archive <- function(
  package,
  files = "R",
  envir = targets::tar_option_get("envir"),
  change_directory = FALSE
) {
  check_string(package, allow_empty = FALSE)
  files <- archive_system_file(files, package = package, envir = parent.frame())
  targets::tar_source(
    files = files,
    envir = envir,
    change_directory = change_directory
  )
}
