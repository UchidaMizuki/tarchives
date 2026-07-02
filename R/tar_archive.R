with_dir_archive <- function(
  package,
  pipeline,
  envir,
  code,
  call = caller_env()
) {
  withr::with_dir(
    archive_system_file(
      pipeline,
      package = package,
      envir = envir,
      call = call
    ),
    code
  )
}

# `pkgload::load_all()`'s `system.file()` shim (which resolves a dev-loaded
# package to its source directory) is only consulted when the call is looked
# up from an environment on the search path, like the global environment --
# not from inside this package's own namespace. Evaluating the call in the
# caller's `envir` instead lets the shim still apply when the ultimate caller
# is on the search path (e.g. an interactive session after `load_all()`).
eval_system_file <- function(..., package, envir) {
  rlang::eval_bare(
    rlang::call2("system.file", ..., package = package),
    env = envir
  )
}

# Resolve a path inside the `inst/tarchives` directory of `package`, erroring
# with an actionable message when the package or the requested file is missing.
archive_system_file <- function(..., package, envir, call = caller_env()) {
  path <- eval_system_file("tarchives", ..., package = package, envir = envir)
  if (!nzchar(path)) {
    if (!nzchar(eval_system_file(package = package, envir = envir))) {
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
#' @param envir An environment used to resolve `package`, so that a package
#' currently loaded with `pkgload::load_all()` (e.g. during interactive
#' package development) is resolved to its source directory instead of its
#' installed one. Defaults to the calling environment.
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
  check_string(package, allow_empty = FALSE)
  check_string(pipeline, allow_empty = FALSE)
  with_dir_archive(
    package = package,
    pipeline = pipeline,
    envir = envir,
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

# Abort with an actionable message when an archived store has not been built
# yet, rather than letting `targets` fail with a less obvious error.
check_archive_store_exists <- function(
  store,
  package,
  pipeline,
  call = caller_env()
) {
  if (!fs::dir_exists(store)) {
    cli::cli_abort(
      c(
        "Can't find the archived store for pipeline {.val {pipeline}} of \\
        package {.pkg {package}}.",
        i = "Have you run {.code tar_make_archive()} for this pipeline yet?"
      ),
      call = call
    )
  }
  invisible(store)
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
      envir = envir,
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
      envir = envir,
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
