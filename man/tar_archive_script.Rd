% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_archive.R
\name{tar_archive_script}
\alias{tar_archive_script}
\title{Path to the archived target script file}
\usage{
tar_archive_script(
  package,
  pipeline,
  script = targets::tar_config_get("script")
)
}
\arguments{
\item{package}{A scalar character of the package name.}

\item{pipeline}{A scalar character of the pipeline name.}

\item{script}{Character of length 1, path to the
target script file. Defaults to \code{tar_config_get("script")},
which in turn defaults to \verb{_targets.R}. When you set
this argument, the value of \code{tar_config_get("script")}
is temporarily changed for the current function call.
See \code{\link[targets:tar_script]{tar_script()}},
\code{\link[targets:tar_config_get]{tar_config_get()}}, and \code{\link[targets:tar_config_set]{tar_config_set()}} for details
about the target script file and how to set it
persistently for a project.}
}
\value{
A scalar character of the path to the archived target script file.
}
\description{
Path to the archived target script file
}
