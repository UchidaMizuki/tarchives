# tar_get_archive() validates its inputs

    Code
      tar_get_archive(model, package = 123, pipeline = "example-model")
    Condition
      Error in `tar_get_archive_raw()`:
      ! `package` must be a single string, not the number 123.

