# tar_meta_archive() errors when the store is not built

    Code
      tar_meta_archive(package = "tarchives", pipeline = "not-built")
    Condition
      Error in `tar_meta_archive()`:
      ! Can't find the archived store for pipeline "not-built" of package tarchives.
      i Have you run `tar_make_archive()` for this pipeline yet?

