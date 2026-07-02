# tarchives 0.1.2

* The archive functions now validate their `package` and `pipeline` arguments and report a clear error when the package or pipeline cannot be found.
* tarchives no longer depends on usethis.
* `tar_archive_pipelines()` lists the pipelines bundled in a package.
* `tar_archive_pipelines()`, `tar_archive_script()`, `tar_make_archive()`, `tar_manifest_archive()`, and `tar_source_archive()` now correctly resolve `package` when it is loaded with `pkgload::load_all()` (e.g. during interactive package development), instead of silently falling back to the installed copy.
* `tar_destroy_archive()` removes the cached store of an archived pipeline.
* `tar_load_archive()` loads archived targets into an environment.
* `tar_manifest_archive()` lists the targets defined in an archived pipeline.
* `tar_meta_archive()` reads the metadata of an archived pipeline's store.
* `tar_read_archive()`, `tar_load_archive()`, and `tar_meta_archive()` now fail with an informative error when the archived store has not been built yet.
* `tar_target_archive()` now builds and reads the archive when the target runs rather than when the target script is sourced, so inspecting a pipeline with `tar_manifest()` or `tar_visnetwork()` no longer triggers a build. The target tracks the installed version of the package, so it refreshes the data when a new version of the package providing the archive is installed and is skipped otherwise.
* Tests no longer leave files in the user cache directory (`tools::R_user_dir("tarchives", "cache")`) during `R CMD check`, which caused the package to be archived on CRAN.

# tarchives 0.1.1

* Added `name_archive` argument to `tar_target_archive()` and `tar_target_archive_raw()` to specify the archived target name separately from the target name.
* Addressed the CRAN Package Check errors.

# tarchives 0.1.0

* Initial CRAN submission.
