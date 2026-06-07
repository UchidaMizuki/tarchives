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

targets::tar_test("tar_read_archive(make = TRUE) builds before reading", {
  tar_destroy_archive(
    package = "tarchives",
    pipeline = "example-model",
    ask = FALSE
  )

  expect_s3_class(
    tar_read_archive(
      model,
      package = "tarchives",
      pipeline = "example-model",
      make = TRUE
    ),
    "lm"
  )
})
