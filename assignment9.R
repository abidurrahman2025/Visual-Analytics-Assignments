# Load required library
library(ggplot2)

# Use mtc dataset
mtc <- mtcars

# Create the plot
ggplot(mtc, aes(x = wt, y = mpg, color = factor(cyl), size = disp)) +
  geom_point() +
  facet_wrap(~factor(am))
