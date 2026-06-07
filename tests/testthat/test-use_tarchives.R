test_that("use_tarchives() sets up inst/tarchives and .Rbuildignore", {
  withr::local_dir(withr::local_tempdir())
  suppressMessages(use_tarchives())

  expect_true(fs::dir_exists("inst/tarchives"))
  expect_in("^inst/tarchives/.*/_targets$", readLines(".Rbuildignore"))
})

test_that("add_build_ignore() appends once and is idempotent", {
  withr::local_dir(withr::local_tempdir())
  suppressMessages(add_build_ignore("^foo$"))
  suppressMessages(add_build_ignore("^foo$"))

  expect_equal(sum(readLines(".Rbuildignore") == "^foo$"), 1L)
})
