library(readr)
library(ggplot2)
library(dplyr)

hotdogs <- read_csv("http://datasets.flowingdata.com/hot-dog-contest-winners.csv")

# Check names
names(hotdogs)
#> "Year" "Winner" "Dogs eaten" "Country" "New record"

# Make syntactic names or rename explicitly
hotdogs <- hotdogs |>
  rename(
    Dogs.eaten = `Dogs eaten`,
    New.record = `New record`
  )

hotdogs <- hotdogs |>
  mutate(
    New.record = factor(New.record),
    label = ifelse(New.record == 1, Dogs.eaten, NA)
  )

ggplot(hotdogs, aes(x = Year, y = Dogs.eaten, fill = New.record)) +
  geom_col(width = 0.8) +
  geom_text(aes(label = label), vjust = -0.3, size = 3, na.rm = TRUE) +
  scale_fill_manual(
    values = c("0" = "grey70", "1" = "firebrick"),
    labels = c("No", "Yes")
  ) +
  labs(
    title = "Nathan's Hot Dog Eating Contest (1980–2010)",
    subtitle = "Record-breaking years highlighted and labeled",
    x = "Year",
    y = "Hot dogs and buns (HDBs) eaten",
    fill = "New record?"
  ) +
  scale_x_continuous(breaks = seq(1980, 2010, by = 5)) +theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  )

