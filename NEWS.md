# tarchives 0.1.2

* The archive functions now validate their `package` and `pipeline` arguments and report a clear error when the package or pipeline cannot be found.
* tarchives no longer depends on usethis.
* `tar_destroy_archive()` removes the cached store of an archived pipeline.
* `tar_load_archive()` loads archived targets into an environment.
* `tar_manifest_archive()` lists the targets defined in an archived pipeline.
* `tar_meta_archive()` reads the metadata of an archived pipeline's store.
* `tar_read_archive()` and `tar_read_archive_raw()` gain a `make` argument to build an out-of-date target before reading, which makes it easy to expose archived data through a plain accessor function.
* `tar_target_archive()` now inspects each archived pipeline only once per session instead of once per declared target, avoiding repeated `tar_outdated()` subprocesses, and it now rebuilds correctly when `name_archive` differs from the target name.
* Tests no longer leave files in the user cache directory (`tools::R_user_dir("tarchives", "cache")`) during `R CMD check`, which caused the package to be archived on CRAN.

# tarchives 0.1.1

* Added `name_archive` argument to `tar_target_archive()` and `tar_target_archive_raw()` to specify the archived target name separately from the target name.
* Addressed the CRAN Package Check errors.

# tarchives 0.1.0

* Initial CRAN submission.
