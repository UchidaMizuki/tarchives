targets::tar_test("tar_target_archive() reads a target from another pipeline", {
  writeLines(
    c(
      "library(targets)",
      "list(",
      "  tarchives::tar_target_archive(",
      "    model,",
      "    package = 'tarchives',",
      "    pipeline = 'example-model'",
      "  )",
      ")"
    ),
    "_targets.R"
  )
  targets::tar_make(reporter = "silent")

  expect_s3_class(targets::tar_read(model), "lm")
})

targets::tar_test("tar_target_archive(name_archive=) reads under a new name", {
  writeLines(
    c(
      "library(targets)",
      "list(",
      "  tarchives::tar_target_archive(",
      "    my_model,",
      "    package = 'tarchives',",
      "    pipeline = 'example-model',",
      "    name_archive = model",
      "  )",
      ")"
    ),
    "_targets.R"
  )
  targets::tar_make(reporter = "silent")

  expect_s3_class(targets::tar_read(my_model), "lm")
  expect_in("my_model", targets::tar_manifest()$name)
})
