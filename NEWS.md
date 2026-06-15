# tarchives 0.1.2

* The archive functions now validate their `package` and `pipeline` arguments and report a clear error when the package or pipeline cannot be found.
* tarchives no longer depends on usethis.
* `tar_destroy_archive()` removes the cached store of an archived pipeline.
* `tar_load_archive()` loads archived targets into an environment.
* `tar_manifest_archive()` lists the targets defined in an archived pipeline.
* `tar_meta_archive()` reads the metadata of an archived pipeline's store.
* `tar_read_archive()`, `tar_load_archive()`, and `tar_meta_archive()` now fail with an informative error when the archived store has not been built yet.
* `tar_target_archive()` no longer errors when it rebuilds an outdated archive while the `cue` argument is left at its default.
* Tests no longer leave files in the user cache directory (`tools::R_user_dir("tarchives", "cache")`) during `R CMD check`, which caused the package to be archived on CRAN.

# tarchives 0.1.1

* Added `name_archive` argument to `tar_target_archive()` and `tar_target_archive_raw()` to specify the archived target name separately from the target name.
* Addressed the CRAN Package Check errors.

# tarchives 0.1.0

* Initial CRAN submission.
