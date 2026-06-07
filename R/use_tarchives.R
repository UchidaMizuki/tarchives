#' Use tarchives
#'
#' Set up tarchives for an existing package.
#'
#' @inheritParams targets::tar_make
#'
#' @return No return value, called for side effects.
#'
#' @export
use_tarchives <- function(store = targets::tar_config_get("store")) {
  check_string(store, allow_empty = FALSE)
  fs::dir_create("inst/tarchives")
  add_build_ignore(paste0("^inst/tarchives/.*/", store, "$"))
}

add_build_ignore <- function(pattern, path = ".Rbuildignore") {
  existing <- if (fs::file_exists(path)) {
    readLines(path, warn = FALSE)
  } else {
    character()
  }
  if (!pattern %in% existing) {
    writeLines(c(existing, pattern), path)
    rlang::inform(paste0(
      "Adding ",
      encodeString(pattern, quote = "'"),
      " to ",
      encodeString(path, quote = "'")
    ))
  }
  invisible(pattern)
}
