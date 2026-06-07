# Package index

## Set up

Add tarchives to a package you are developing.

- [`use_tarchives()`](https://uchidamizuki.github.io/tarchives/reference/use_tarchives.md)
  : Use tarchives

## Run and read archived pipelines

tarchives versions of the main targets functions.

- [`tar_make_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_make_archive.md)
  : Run an archived pipeline of targets.
- [`tar_read_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_read_archive.md)
  [`tar_read_archive_raw()`](https://uchidamizuki.github.io/tarchives/reference/tar_read_archive.md)
  : Read a target's value from archive storage
- [`tar_load_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_load_archive.md)
  : Load a target's value from archive storage
- [`tar_source_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_source_archive.md)
  : Run archived R scripts.
- [`tar_target_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_target_archive.md)
  [`tar_target_archive_raw()`](https://uchidamizuki.github.io/tarchives/reference/tar_target_archive.md)
  : Declare a target to read an archive.

## Inspect and manage storage

Inspect archived pipelines and clear their cached stores.

- [`tar_meta_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_meta_archive.md)
  : Read metadata from archive storage
- [`tar_manifest_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_manifest_archive.md)
  : List the targets of an archived pipeline
- [`tar_destroy_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_destroy_archive.md)
  : Destroy an archived pipeline's storage

## Lower-level helpers

Locate archive scripts and stores, or wrap targets functions directly.

- [`tar_archive()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive.md)
  : Function factory for archived targets
- [`tar_archive_script()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_script.md)
  : Path to the archived target script file
- [`tar_archive_store()`](https://uchidamizuki.github.io/tarchives/reference/tar_archive_store.md)
  : Path to the archived target store directory
