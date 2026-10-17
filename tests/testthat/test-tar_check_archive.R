test_that("tar_check_archive_pipeline() passes through a valid pipeline", {
  expect_equal(
    tar_check_archive_pipeline("example-model", package = "tarchives"),
    "example-model"
  )
})

test_that("tar_check_archive_pipeline() errors and suggests a pipeline", {
  expect_snapshot(
    error = TRUE,
    tar_check_archive_pipeline("example-modle", package = "tarchives")
  )
})

test_that("tar_check_archive_name() passes through a valid name", {
  expect_equal(
    tar_check_archive_name(
      "data",
      package = "tarchives",
      pipeline = "example-model"
    ),
    "data"
  )
})

test_that("tar_check_archive_name() errors and suggests a name", {
  expect_snapshot(
    error = TRUE,
    tar_check_archive_name(
      "dta",
      package = "tarchives",
      pipeline = "example-model"
    )
  )
})

test_that("tar_check_archive_name() keeps the caller's session", {
  withr::defer(targets::tar_option_reset())
  withr::defer(rlang::env_unbind(archive_names_cache, "tarchives"))
  dir <- withr::local_tempdir()
  writeLines(
    c(
      "library(targets)",
      "tar_option_set(packages = \"upstream\")",
      "options(tarchives.upstream = TRUE)",
      "list(tar_target(x, 1))"
    ),
    file.path(dir, "_targets.R")
  )
  local_mocked_bindings(archive_system_file = function(...) dir)
  targets::tar_option_set(packages = "user")
  tar_check_archive_name("x", package = "tarchives", pipeline = "options")
  expect_equal(targets::tar_option_get("packages"), "user")
  expect_null(getOption("tarchives.upstream"))
})

test_that("tar_check_archive_name() reads each pipeline once", {
  withr::defer(rlang::env_unbind(archive_names_cache, "tarchives"))
  calls <- 0
  local_mocked_bindings(
    tar_manifest_archive = function(...) {
      calls <<- calls + 1
      data.frame(name = c("data", "model"))
    }
  )
  for (name in c("data", "model", "data")) {
    tar_check_archive_name(name, package = "tarchives", pipeline = "cache")
  }
  expect_equal(calls, 1)
})

test_that("tar_check_archive_name() skips checks while reading names", {
  withr::defer(rlang::env_unbind(archive_names_cache, "tarchives"))
  local_mocked_bindings(
    tar_manifest_archive = function(...) {
      data.frame(
        name = tar_check_archive_name(
          "nested",
          package = "tarchives",
          pipeline = "other"
        )
      )
    }
  )
  expect_equal(
    tar_check_archive_name("nested", package = "tarchives", pipeline = "outer"),
    "nested"
  )
})
