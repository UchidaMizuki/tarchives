## R CMD check results

0 errors | 0 warnings | 1 note

* The note is "New submission", because the package was archived (see below) and
  is being resubmitted.

## Resubmission

This package was archived on 2026-03-03 because its tests left files in the
user cache directory (`~/.cache/R/tarchives`, from
`tools::R_user_dir("tarchives", "cache")`) during `R CMD check`, and this was
not corrected in time.

The tests now redirect the cache to a temporary directory (via the
`R_USER_CACHE_DIR` environment variable) for the duration of the test run, so
`R CMD check` no longer leaves any files behind.
