# tar_read_archive() errors when the store is not built

    Code
      tar_read_archive(model, package = "tarchives", pipeline = "not-built")
    Condition
      Error in `tar_read_archive_raw()`:
      ! Can't find the archived store for pipeline "not-built" of package tarchives.
      i Have you run `tar_make_archive()` for this pipeline yet?

