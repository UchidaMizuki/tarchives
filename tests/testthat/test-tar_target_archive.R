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

targets::tar_test("tar_target_archive() rebuilds an outdated archive", {
  # Destroy the archive so the target has to build it when it runs.
  tar_destroy_archive(
    package = "tarchives",
    pipeline = "example-model",
    ask = FALSE
  )
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

targets::tar_test("tar_target_archive() does not build when the script is sourced", {
  tar_destroy_archive(
    package = "tarchives",
    pipeline = "example-model",
    ask = FALSE
  )
  store <- tar_archive_store(
    package = "tarchives",
    pipeline = "example-model"
  )
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
  # Sourcing the script (here via `tar_manifest()`) must not trigger a build.
  expect_in("model", targets::tar_manifest()$name)
  expect_false(unname(fs::dir_exists(store)))
})
