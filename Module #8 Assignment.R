# Load required packages
library(ggplot2)
library(tidyverse)

# Use mtcars as mtc
mtc <- mtcars

# 1. Compute and display correlation matrix
cor(mtc)

# 2. Fit linear models (example using lm() explicitly)
model1 <- lm(mpg ~ wt, data = mtc)
summary(model1)
model2 <-lm(mpg ~ hp, data = mtc)
summary(model2)
model3 <-lm(mpg ~ disp, data = mtc)
summary(model3)

# 3. Prepare data for faceted scatter plots
mtc_long <- mtc %>%
  select(mpg, wt, hp, disp) %>%
  pivot_longer(-mpg, names_to = "predictor", values_to = "value")

# 4. Create faceted scatter plots with regression lines
ggplot(mtc_long, aes(x = value, y = mpg)) +
  geom_point(color = "gray30") +
  stat_smooth(method = "lm", se = FALSE, color = "black") +
  facet_wrap(~predictor, scales = "free_x") +
  labs(title = "Relationships Between MPG and Vehicle Characteristics",
       x = "Predictor value", y = "Miles per gallon (mpg)") +
  theme_minimal()
