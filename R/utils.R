script_file <- function(package, pipeline, script) {
  system.file("tarchives", pipeline, script,
              package = package,
              mustWork = TRUE)
}

store_dir <- function(package, pipeline, store) {
  user_dir <- tools::R_user_dir("tarchives",
                                which = "cache")
  fs::path(user_dir, package, pipeline, store)
}
