targets::tar_test("tar_manifest_archive() lists the targets", {
  manifest <- tar_manifest_archive(
    package = "tarchives",
    pipeline = "example-model"
  )
  expect_in(c("data", "model"), manifest$name)
})
