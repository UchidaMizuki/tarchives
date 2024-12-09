script_file <- function(package, pipeline, script, envir) {
  rlang::eval_tidy(rlang::expr(system.file("tarchives", pipeline, script,
                                           package = package,
                                           mustWork = TRUE)),
                   data = list(package = package,
                               pipeline = pipeline,
                               script = script),
                   env = envir)
}

store_dir <- function(package, pipeline, store) {
  user_dir <- tools::R_user_dir("tarchives",
                                which = "cache")
  fs::path(user_dir, package, pipeline, store)
}
