targets::tar_test("tar_read_archive() works", {
  tar_make_archive(
    package = "tarchives",
    pipeline = "example-model"
  )

  expect_s3_class(
    tar_read_archive(
      model,
      package = "tarchives",
      pipeline = "example-model"
    ),
    "lm"
  )
})

targets::tar_test("tar_read_archive() errors when the store is not built", {
  expect_snapshot(
    error = TRUE,
    tar_read_archive(
      model,
      package = "tarchives",
      pipeline = "not-built"
    )
  )
})
