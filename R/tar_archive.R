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
    envir = parent.frame(),
    script = targets::tar_config_get("script")
) {
  script <- rlang::eval_tidy(
    rlang::call2(
      "system.file",
      "tarchives", pipeline, script,
      package = package,
      mustWork = TRUE
    ),
    env = envir
  )
  fs::as_fs_path(script)
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

#' Function factory for archived targets
#'
#' @param f A function of targets package.
#' @param package A scalar character of the package name.
#' @param pipeline A scalar character of the pipeline name.
#' @param ... Arguments to pass to [targets::tar_make()] etc.
#' @inheritParams targets::tar_make
#'
#' @return A function.
#'
#' @export
tar_archive <- function(
    f,
    package,
    pipeline,
    envir = parent.frame(),
    script = targets::tar_config_get("script"),
    store = targets::tar_config_get("store")
) {
  fmls <- rlang::fn_fmls(f)

  args <- list()
  if ("envir" %in% names(fmls)) {
    args$envir <- envir
  }
  if ("script" %in% names(fmls)) {
    args$script <- tar_archive_script(
      package = package,
      pipeline = pipeline,
      script = script,
      envir = envir
    )
  }
  if ("store" %in% names(fmls)) {
    args$store <- tar_archive_store(
      package = package,
      pipeline = pipeline,
      store = store
    )
  }

  function(...) {
    rlang::eval_tidy(
      rlang::call2(
        f,
        !!!args,
        !!!rlang::enexprs(...)
      ),
      data = as.list(fmls),
      env = envir
    )
  }
}
