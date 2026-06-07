targets::tar_test("tar_source_archive() works", {
  expect_no_error(
    tar_source_archive(
      "tarchives"
    )
  )
})

test_that("tar_source_archive() errors for an unknown package", {
  expect_snapshot(
    error = TRUE,
    tar_source_archive(
      "tarchives-wrong"
    )
  )
})
