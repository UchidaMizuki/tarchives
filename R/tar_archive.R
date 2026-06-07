with_dir_archive <- function(
  package,
  pipeline,
  code,
  call = caller_env()
) {
  withr::with_dir(
    archive_system_file(pipeline, package = package, call = call),
    code
  )
}

# Resolve a path inside the `inst/tarchives` directory of `package`, erroring
# with an actionable message when the package or the requested file is missing.
archive_system_file <- function(..., package, call = caller_env()) {
  path <- system.file("tarchives", ..., package = package)
  if (!nzchar(path)) {
    if (!nzchar(system.file(package = package))) {
      cli::cli_abort(
        c(
          "Can't find package {.pkg {package}}.",
          i = "Is it installed?"
        ),
        call = call
      )
    }
    file <- file.path(...)
    cli::cli_abort(
      "Can't find {.file {file}} in the {.path inst/tarchives} directory of \\
      package {.pkg {package}}.",
      call = call
    )
  }
  path
}

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
  script = targets::tar_config_get("script")
) {
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  with_dir_archive(
    package = package,
    pipeline = pipeline,
    fs::path_wd(script)
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
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  fs::path(
    tools::R_user_dir(
      "tarchives",
      which = "cache"
    ),
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
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  fmls_names <- rlang::fn_fmls_names(f)

  args <- list()
  if ("envir" %in% fmls_names) {
    args$envir <- envir
  }
  if ("script" %in% fmls_names) {
    args$script <- tar_archive_script(
      package = package,
      pipeline = pipeline,
      script = script
    )
  }
  if ("store" %in% fmls_names) {
    args$store <- tar_archive_store(
      package = package,
      pipeline = pipeline,
      store = store
    )
  }
  function(...) {
    with_dir_archive(
      package = package,
      pipeline = pipeline,
      rlang::eval_tidy(
        rlang::call2(
          "f",
          !!!args,
          !!!rlang::enexprs(...)
        ),
        data = list(f = f),
        env = envir
      )
    )
  }
}
