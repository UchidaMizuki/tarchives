targets::tar_test("tar_make_archive() works", {
  expect_no_error(
    tar_make_archive(
      package = "tarchives",
      pipeline = "example-model"
    )
  )
})

test_that("tar_make_archive() errors for an unknown package", {
  expect_snapshot(
    error = TRUE,
    tar_make_archive(
      package = "tarchives-wrong",
      pipeline = "example-model"
    )
  )
})

test_that("tar_make_archive() errors for an unknown pipeline", {
  expect_snapshot(
    error = TRUE,
    tar_make_archive(
      package = "tarchives",
      pipeline = "example-model-wrong"
    )
  )
})

test_that("tar_make_archive() validates its inputs", {
  expect_snapshot(
    error = TRUE,
    tar_make_archive(
      package = 123,
      pipeline = "example-model"
    )
  )
})

targets::tar_test("tar_make_archive() explains a missing package", {
  withr::local_language("en")
  dir <- withr::local_tempdir()
  writeLines(
    "library(targets); list(tar_target(x, tarchivesnotapackage::f()))",
    file.path(dir, "_targets.R")
  )
  local_mocked_bindings(archive_system_file = function(...) dir)
  expect_snapshot(
    error = TRUE,
    tar_make_archive(package = "tarchives", pipeline = "missing-package"),
    transform = \(x) gsub("[‘’]", "'", x)
  )
})

targets::tar_test("tar_make_archive() adds context to build errors", {
  withr::local_language("en")
  dir <- withr::local_tempdir()
  writeLines(
    "library(targets); list(tar_target(x, stop(\"Upstream is down.\")))",
    file.path(dir, "_targets.R")
  )
  local_mocked_bindings(archive_system_file = function(...) dir)
  expect_error(
    tar_make_archive(package = "tarchives", pipeline = "failing"),
    class = "tarchives_error_build"
  )
})

test_that("local_archive_lock() holds the lock until exit", {
  store <- file.path(withr::local_tempdir(), "_targets")
  locked_elsewhere <- function() {
    callr::r(
      \(path) is.null(filelock::lock(path, timeout = 0)),
      args = list(path = paste0(store, ".lock"))
    )
  }
  f <- function() {
    local_archive_lock(store = store, package = "pkg", pipeline = "pipe")
    locked_elsewhere()
  }
  expect_identical(f(), TRUE)
  expect_identical(locked_elsewhere(), FALSE)
})

test_that("local_archive_lock() waits for another process", {
  skip_on_cran()
  store <- file.path(withr::local_tempdir(), "_targets")
  path <- paste0(store, ".lock")
  ready <- paste0(store, ".ready")
  holder <- callr::r_bg(
    function(path, ready) {
      lock <- filelock::lock(path)
      file.create(ready)
      Sys.sleep(2)
      filelock::unlock(lock)
    },
    args = list(path = path, ready = ready)
  )
  withr::defer(holder$kill())
  while (!file.exists(ready)) {
    Sys.sleep(0.05)
  }
  f <- function() {
    local_archive_lock(store = store, package = "pkg", pipeline = "pipe")
  }
  expect_snapshot(f())
})
