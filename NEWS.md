# tarchives 0.1.2

* Tests no longer leave files in the user cache directory (`tools::R_user_dir("tarchives", "cache")`) during `R CMD check`, which caused the package to be archived on CRAN.

# tarchives 0.1.1

* Added `name_archive` argument to `tar_target_archive()` and `tar_target_archive_raw()` to specify the archived target name separately from the target name.
* Addressed the CRAN Package Check errors.

# tarchives 0.1.0

* Initial CRAN submission.
