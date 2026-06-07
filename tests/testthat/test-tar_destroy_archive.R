targets::tar_test("tar_destroy_archive() removes the store", {
  tar_make_archive(
    package = "tarchives",
    pipeline = "example-model"
  )
  store <- tar_archive_store(
    package = "tarchives",
    pipeline = "example-model"
  )
  expect_equal(unname(fs::dir_exists(store)), TRUE)

  tar_destroy_archive(
    package = "tarchives",
    pipeline = "example-model",
    ask = FALSE
  )
  expect_equal(unname(fs::dir_exists(store)), FALSE)
})
