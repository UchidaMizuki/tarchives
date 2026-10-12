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
    tar_make_archive(package = "tarchives", pipeline = "missing-package")
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
