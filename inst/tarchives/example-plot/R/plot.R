# Return the data needed to plot the model fit. Returning a value (rather than
# drawing to a device) keeps the target reproducible in a non-interactive
# session, where the previous `if (interactive())` branch stored `NULL`.
get_plot <- function(data, model) {
  data$fitted <- predict(model, newdata = data)
  data
}
