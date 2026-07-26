targets::tar_test("tar_get_archive() works", {
  expect_s3_class(
    tar_get_archive(model, package = "tarchives", pipeline = "example-model"),
    "lm"
  )
})

targets::tar_test("tar_get_archive() builds different names in the same pipeline independently", {
  expect_s3_class(
    tar_get_archive(data, package = "tarchives", pipeline = "example-model"),
    "data.frame"
  )
  expect_s3_class(
    tar_get_archive(model, package = "tarchives", pipeline = "example-model"),
    "lm"
  )
})

test_that("tar_get_archive() validates its inputs", {
  expect_snapshot(
    error = TRUE,
    tar_get_archive(model, package = 123, pipeline = "example-model")
  )
})

test_that("archive_built() tracks build state per target name", {
  expect_false(archive_built(
    package = "tarchives",
    pipeline = "test-pipeline",
    name = "a"
  ))

  archive_mark_built(
    package = "tarchives",
    pipeline = "test-pipeline",
    name = "a"
  )
  expect_true(archive_built(
    package = "tarchives",
    pipeline = "test-pipeline",
    name = "a"
  ))
  expect_false(archive_built(
    package = "tarchives",
    pipeline = "test-pipeline",
    name = "b"
  ))

  archive_mark_built(
    package = "tarchives",
    pipeline = "test-pipeline",
    name = "b"
  )
  expect_true(archive_built(
    package = "tarchives",
    pipeline = "test-pipeline",
    name = "a"
  ))
  expect_true(archive_built(
    package = "tarchives",
    pipeline = "test-pipeline",
    name = "b"
  ))
})
