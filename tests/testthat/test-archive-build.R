targets::tar_test("archive_outdated() returns nothing for a built pipeline", {
  tar_make_archive(
    package = "tarchives",
    pipeline = "example-model"
  )
  store <- tar_archive_store(
    package = "tarchives",
    pipeline = "example-model"
  )

  outdated <- archive_outdated("tarchives", "example-model", store)
  expect_length(outdated, 0L)
  # A second call returns the memoised value.
  expect_identical(
    archive_outdated("tarchives", "example-model", store),
    outdated
  )
})

targets::tar_test("ensure_archive_built() builds an out-of-date target", {
  tar_destroy_archive(
    package = "tarchives",
    pipeline = "example-model",
    ask = FALSE
  )
  store <- tar_archive_store(
    package = "tarchives",
    pipeline = "example-model"
  )

  built <- ensure_archive_built("tarchives", "example-model", "model", store)
  expect_in("model", built)
  expect_s3_class(
    tar_read_archive(model, package = "tarchives", pipeline = "example-model"),
    "lm"
  )
})
