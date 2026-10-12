# tar_make_archive() errors for an unknown package

    Code
      tar_make_archive(package = "tarchives-wrong", pipeline = "example-model")
    Condition
      Error in `tar_archive_script()`:
      ! Can't find package tarchives-wrong.
      i Is it installed?

# tar_make_archive() errors for an unknown pipeline

    Code
      tar_make_archive(package = "tarchives", pipeline = "example-model-wrong")
    Condition
      Error in `tar_archive_script()`:
      ! Can't find 'example-model-wrong' in the 'inst/tarchives' directory of package tarchives.

# tar_make_archive() validates its inputs

    Code
      tar_make_archive(package = 123, pipeline = "example-model")
    Condition
      Error in `tar_make_archive()`:
      ! `package` must be a single string, not the number 123.

# tar_make_archive() explains a missing package

    Code
      tar_make_archive(package = "tarchives", pipeline = "missing-package")
    Condition
      Error in `tar_make_archive()`:
      ! Can't build pipeline "missing-package" of package tarchives.
      i The pipeline needs a package that isn't installed.
      i Packages needed only to build a pipeline are often suggested dependencies of tarchives, which aren't installed by default. To install them, run `install.packages("tarchives", dependencies = TRUE)`.
      Caused by error:
      ! Error in tar_make():
        there is no package called 'tarchivesnotapackage'
        See https://books.ropensci.org/targets/debugging.html

# local_archive_lock() waits for another process

    Code
      f()
    Message
      Waiting for another R process to finish building pipeline "pipe" of package pkg.

