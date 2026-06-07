targets::tar_test("tar_archive_script() works", {
  script <- tar_archive_script(
    package = "tarchives",
    pipeline = "example-model"
  )
  expect_equal(unname(fs::is_file(script)), TRUE)
})

targets::tar_test("tar_archive() works", {
  # targets::tar_outdated() for archived targets works
  tar_outdated_example_model <- tar_archive(
    targets::tar_outdated,
    package = "tarchives",
    pipeline = "example-model"
  )

  if (!"model" %in% tar_outdated_example_model()) {
    tar_delete_example_model <- tar_archive(
      targets::tar_delete,
      package = "tarchives",
      pipeline = "example-model"
    )
    tar_delete_example_model(model)
  }
  expect_in("model", tar_outdated_example_model())

  tar_outdated_example_plot <- tar_archive(
    targets::tar_outdated,
    package = "tarchives",
    pipeline = "example-plot"
  )
  expect_in("plot", tar_outdated_example_plot())

  tar_make_archive(
    package = "tarchives",
    pipeline = "example-plot",
    names = plot
  )
  expect_vector(tar_outdated_example_model(), character(), 0)
  expect_vector(tar_outdated_example_plot(), character(), 0)

  store <- tar_archive_store(
    package = "tarchives",
    pipeline = "example-model"
  )
  expect_equal(unname(fs::is_dir(store)), TRUE)
})
