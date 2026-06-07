# Redirect the user cache directory to a temporary location for the duration
# of the test run. The pipelines exercised in the tests write their `targets`
# stores under `tools::R_user_dir("tarchives", "cache")`, which resolves to the
# real user cache (e.g. `~/.cache/R/tarchives`). `tar_test()` only isolates the
# working directory, so without this those files are left behind after
# `R CMD check` -- a CRAN policy violation. `R_user_dir()` honours the
# `R_USER_CACHE_DIR` environment variable, so pointing it at a temporary
# directory keeps the cache inside `tempdir()` and removes it after all tests.
withr::local_envvar(
  R_USER_CACHE_DIR = withr::local_tempdir(.local_envir = teardown_env()),
  .local_envir = teardown_env()
)
