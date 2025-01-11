get_plot <- function(data, model) {
  plot(Sepal.Width ~ Sepal.Length, data = data)
  abline(model)
}