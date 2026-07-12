# Changelog

## tarchives (development version)

## tarchives 0.2.0

CRAN release: 2026-07-12

- The archive functions now validate their `package` and `pipeline`
  arguments and report a clear error when the package or pipeline cannot
  be found.
- tarchives no longer depends on usethis.
- [`tar_archive_pipelines()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_pipelines.md)
  lists the pipelines bundled in a package.
- [`tar_archive_pipelines()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_pipelines.md),
  [`tar_archive_script()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_script.md),
  [`tar_make_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_make_archive.md),
  [`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md),
  and
  [`tar_source_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_source_archive.md)
  now correctly resolve `package` when it is loaded with
  [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
  (e.g. during interactive package development), instead of silently
  falling back to the installed copy.
- [`tar_destroy_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_destroy_archive.md)
  removes the cached store of an archived pipeline.
- [`tar_load_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_load_archive.md)
  loads archived targets into an environment.
- [`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md)
  lists the targets defined in an archived pipeline.
- [`tar_meta_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_meta_archive.md)
  reads the metadata of an archived pipeline’s store.
- [`tar_read_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_read_archive.md),
  [`tar_load_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_load_archive.md),
  and
  [`tar_meta_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_meta_archive.md)
  now fail with an informative error when the archived store has not
  been built yet.
- [`tar_target_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_target_archive.md)
  now builds and reads the archive when the target runs rather than when
  the target script is sourced, so inspecting a pipeline with
  [`tar_manifest()`](https://docs.ropensci.org/targets/reference/tar_manifest.html)
  or
  [`tar_visnetwork()`](https://docs.ropensci.org/targets/reference/tar_visnetwork.html)
  no longer triggers a build. The target tracks the installed version of
  the package, so it refreshes the data when a new version of the
  package providing the archive is installed and is skipped otherwise.
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
