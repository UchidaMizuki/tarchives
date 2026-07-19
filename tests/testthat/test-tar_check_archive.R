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
