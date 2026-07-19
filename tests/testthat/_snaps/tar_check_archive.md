# tar_check_archive_pipeline() errors and suggests a pipeline

    Code
      tar_check_archive_pipeline("example-modle", package = "tarchives")
    Condition
      Error:
      ! `"example-modle"` must be one of "example-model" or "example-plot", not "example-modle".
      i Did you mean "example-model"?

# tar_check_archive_name() errors and suggests a name

    Code
      tar_check_archive_name("dta", package = "tarchives", pipeline = "example-model")
    Condition
      Error:
      ! `"dta"` must be one of "data" or "model", not "dta".
      i Did you mean "data"?

