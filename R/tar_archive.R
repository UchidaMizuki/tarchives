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
    store = targets::tar_config_get("store"), ...
) {
  fmls_names <- rlang::fn_fmls_names(f)

  args <- rlang::list2(...)
  if ("envir" %in% fmls_names) {
    args$envir <- envir
  }
  if ("script" %in% fmls_names) {
    args$script <- script_file(
      package = package,
      pipeline = pipeline,
      script = script,
      envir = envir
    )
  }
  if ("store" %in% fmls_names) {
    args$store <- store_dir(
      package = package,
      pipeline = pipeline,
      store = store
    )
  }

  if (identical(f, targets::tar_read) ||
      identical(f, targets::tar_read_raw)) {
    tar_read_archive_impl(f, args)
  } else if (identical(f, targets::tar_target) ||
             identical(f, targets::tar_target_raw)) {
    tar_target_archive_impl(f, args,
                            package = package,
                            pipeline = pipeline,
                            envir = envir,
                            script = script,
                            store = store)
  } else {
    tar_archive_impl(f, args)
  }
}

tar_archive_impl <- function(f, args) {
  fmls_names <- rlang::fn_fmls_names(f)
  args <- args[names(args) %in% fmls_names]

  function(...) {
    rlang::exec(f, !!!args, ...)
  }
}
