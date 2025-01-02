#' Path to the archived target script file
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_make
#'
#' @return A scalar character of the path to the archived target script file.
#'
#' @export
tar_archive_script <- function(
    package,
    pipeline,
    script = targets::tar_config_get("script"),
    envir = parent.frame()
) {
  rlang::eval_tidy(
    rlang::call2(
      "system.file",
      "tarchives", pipeline, script,
      package = package,
      mustWork = TRUE
    ),
    env = envir
  )
}

#' Path to the archived target store directory
#'
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @inheritParams targets::tar_make
#'
#' @return A scalar character of the path to the archived target store
#' directory.
#'
#' @export
tar_archive_store <- function(
    package,
    pipeline,
    store = targets::tar_config_get("store")
) {
  fs::path(
    tools::R_user_dir("tarchives",
                      which = "cache"),
    package,
    pipeline,
    store
  )
}
