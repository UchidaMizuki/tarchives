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

# Fingerprint the installed source of an archived pipeline (package version
# plus the contents of the pipeline directory and the shared `R/` helpers).
# This only reads and hashes source files -- it never runs the pipeline -- so
# it is cheap and side-effect free, and it lets a target detect when the
# package providing the archive has changed. The cached `_targets` store is
# excluded because it is not part of the pipeline's source.
tar_archive_fingerprint <- function(package, pipeline, call = caller_env()) {
  pipeline_dir <- archive_system_file(pipeline, package = package, call = call)
  store_dir <- fs::path(pipeline_dir, "_targets")
  dirs <- pipeline_dir
  shared_r <- system.file("tarchives", "R", package = package)
  if (nzchar(shared_r)) {
    dirs <- c(dirs, shared_r)
  }
  files <- unlist(lapply(dirs, function(dir) {
    as.character(fs::dir_ls(dir, recurse = TRUE, type = "file"))
  }))
  files <- files[!fs::path_has_parent(files, store_dir)]
  files <- sort(unique(files))
  pkg_root <- system.file(package = package)
  rlang::hash(list(
    version = as.character(utils::packageVersion(package)),
    files = as.character(fs::path_rel(files, pkg_root)),
    hashes = unname(tools::md5sum(files))
  ))
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
