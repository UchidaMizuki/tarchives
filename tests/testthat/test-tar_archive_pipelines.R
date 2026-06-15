test_that("tar_archive_pipelines() lists the bundled pipelines", {
  expect_equal(
    tar_archive_pipelines("tarchives"),
    c("example-model", "example-plot")
  )
})

test_that("tar_archive_pipelines() errors for a missing package", {
  expect_snapshot(
    error = TRUE,
    tar_archive_pipelines("notapackage")
  )
})
