# Changelog

## tarchives 0.1.2

- The archive functions now validate their `package` and `pipeline`
  arguments and report a clear error when the package or pipeline cannot
  be found.
- tarchives no longer depends on usethis.
- [`tar_destroy_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_destroy_archive.md)
  removes the cached store of an archived pipeline.
- [`tar_load_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_load_archive.md)
  loads archived targets into an environment.
- [`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md)
  lists the targets defined in an archived pipeline.
- [`tar_meta_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_meta_archive.md)
  reads the metadata of an archived pipeline’s store.
- Tests no longer leave files in the user cache directory
  (`tools::R_user_dir("tarchives", "cache")`) during `R CMD check`,
  which caused the package to be archived on CRAN.

## tarchives 0.1.1

CRAN release: 2025-06-22

- Added `name_archive` argument to
  [`tar_target_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_target_archive.md)
  and
  [`tar_target_archive_raw()`](https://uchidamizuki.github.io/tarchives/reference/tar_target_archive.md)
  to specify the archived target name separately from the target name.
- Addressed the CRAN Package Check errors.

## tarchives 0.1.0

CRAN release: 2025-06-04

- Initial CRAN submission.
