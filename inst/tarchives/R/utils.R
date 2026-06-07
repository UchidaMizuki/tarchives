# Shared R scripts for the bundled example pipelines.
#
# Sourced by `tarchives::tar_source_archive("tarchives")` so that helper
# functions placed in `inst/tarchives/R` are available to every archived
# pipeline shipped with the package.

# Drop the setosa species so the example model compares two groups.
drop_setosa <- function(data) {
  data[data$Species != "setosa", ]
}
