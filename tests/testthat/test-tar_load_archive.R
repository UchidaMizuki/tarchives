targets::tar_test("tar_load_archive() loads a target into an environment", {
  tar_make_archive(
    package = "tarchives",
    pipeline = "example-model"
  )

  envir <- new.env()
  tar_load_archive(
    model,
    package = "tarchives",
    pipeline = "example-model",
    envir = envir
  )
  expect_s3_class(envir$model, "lm")
})

targets::tar_test("tar_load_archive() errors when the store is not built", {
  expect_snapshot(
    error = TRUE,
    tar_load_archive(
      model,
      package = "tarchives",
      pipeline = "not-built"
    )
  )
})
