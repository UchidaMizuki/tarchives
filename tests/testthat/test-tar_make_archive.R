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
