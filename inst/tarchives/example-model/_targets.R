library(targets)

tarchives::tar_source_archive("tarchives")

list(
  tar_target(
    data,
    drop_setosa(iris)
  ),
  tar_target(
    model,
    lm(Sepal.Width ~ Sepal.Length, data)
  )
)
