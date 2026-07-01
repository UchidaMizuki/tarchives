targets::tar_test("tar_meta_archive() returns metadata", {
  tar_make_archive(
    package = "tarchives",
    pipeline = "example-model"
  )

  meta <- tar_meta_archive(
    package = "tarchives",
    pipeline = "example-model"
  )
  expect_in("model", meta$name)
})

targets::tar_test("tar_meta_archive() errors when the store is not built", {
  expect_snapshot(
    error = TRUE,
    tar_meta_archive(
      package = "tarchives",
      pipeline = "not-built"
    )
  )
})
