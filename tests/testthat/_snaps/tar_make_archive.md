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

