library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)

# Load the dataset
vehicles <- read_csv("https://www.fueleconomy.gov/feg/epadata/vehicles.csv", show_col_types = FALSE)

# DATA CLEANING & RE-CATEGORIZATION
df <- vehicles %>%
  select(make, model, year, VClass , cylinders, displ, drive, trany, comb08, highway08, city08, fuelType1) %>%
  # Remove rows with missing critical values
  filter(!is.na(year), !is.na(comb08), !is.na(displ), !is.na(trany)) %>%
  mutate(
    # Broadening the search terms to capture all variations
    vehicle_class = case_when(
      grepl("SUV|Sport Utility", VClass , ignore.case = TRUE) ~ "SUV",
      grepl("Wagon|Sedan|Passenger Car", VClass , ignore.case = TRUE) ~ "Car",
      grepl("Truck|Pickup", VClass , ignore.case = TRUE) ~ "Truck",
      TRUE ~ "Other"
    ),
    drivetrain = case_when(
      grepl("Auto", trany, ignore.case = TRUE) ~ "Automatic",
      grepl("Manual", trany, ignore.case = TRUE) ~ "Manual",
      TRUE ~ "Other"
    )
  ) %>%
  # Keep only the primary classes for the analysis
  filter(vehicle_class %in% c("SUV", "Car", "Truck"), drivetrain %in% c("Automatic", "Manual"))

# AGGREGATION FOR TREND LINES
trend <- df %>%
  group_by(year, vehicle_class) %>%
  summarise(
    avg_mpg = mean(comb08, na.rm = TRUE), 
    avg_displ = mean(displ, na.rm = TRUE), 
    n = n(), 
    .groups = "drop"
  )
avg_all <- df %>%
  group_by(year) %>%
  summarise(avg_mpg_all = mean(comb08, na.rm = TRUE), .groups = "drop")

# ORGANIZE PLOTTING ORDER
class_order <- trend %>% 
  group_by(vehicle_class) %>% 
  summarise(m = mean(avg_mpg), .groups = "drop") %>% 
  arrange(desc(m)) %>% 
  pull(vehicle_class)

trend$vehicle_class <- factor(trend$vehicle_class, levels = class_order)
df$vehicle_class <- factor(df$vehicle_class, levels = class_order)

# Plot 1: Density plot of MPG
plot1 <- ggplot(df, aes(x = comb08, fill = vehicle_class, color = vehicle_class)) +
  geom_density(alpha = 0.22, linewidth = 0.8) +
  theme_minimal(base_size = 12) +
  labs(
    title = "MPG Distribution by Class",
    x = "Combined MPG",
    y = "Count"
    )+
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

# Plot 2: Bar plot of vehicle counts by class and year group
df_year <- df %>%
  mutate(period = cut(
    year,
    breaks = c(1974, 1985, 1995, 2005, 2015, 2026),
    labels = c("1975-1985", "1986-1995", "1996-2005", "2006-2015", "2016-2025"),
    include.lowest = TRUE,
    right = TRUE
  ))

count_tbl <- df_year %>%
  count(period, vehicle_class) %>%
  group_by(period) %>%
  mutate(share = n / sum(n)) %>%
  ungroup()

plot2 <- ggplot(count_tbl, aes(x = period, y = share, fill = vehicle_class)) +
  geom_col(position = "stack", width = 0.75) +
  scale_y_continuous() +
  labs(
    title = "Vehicle Shifts by Classes",
    x = "Model Year Period",
    y = "Share of Vehicles",
    fill = "Class"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

# VISUALIZATION 3: The Efficiency Trade-off
plot3 <- ggplot(df, aes(x = displ, y = comb08, color = vehicle_class)) +
  geom_point(alpha = 0.15, size = 1.1) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  facet_wrap(~ vehicle_class) +
  labs(title = "Displacement vs. MPG", 
       subtitle = "How engine size affects efficiency by class",
       x = "Engine Displacement (L)", y = "Combined MPG") +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank(), legend.position = "none")

# Filter for Gasoline/Diesel to see "Pure" Engine Improvements
avg_gasoline <- df %>%
  filter(fuelType1 %in% c("Regular Gasoline", "Premium Gasoline", "Diesel")) %>%
  group_by(year) %>%
  summarise(avg_mpg_gas = mean(comb08, na.rm = TRUE), .groups = "drop")

# Plot 4: Gasoline-Only Average Combined MPG Over Time
plot4 <- ggplot(avg_gasoline, aes(x = year, y = avg_mpg_gas)) +
  geom_line(linewidth = 1, color = "#E41A1C") + # Red line for ICE
  geom_point(size = 1.6, color = "#E41A1C") +
  scale_x_continuous(breaks = seq(1984, 2026, by = 5)) +
  scale_y_continuous(limits = c(15, 30), expand = expansion(mult = c(0, 0.05))) +
  labs(
    title = "Pure Engine Efficiency Trends (Gasoline/Diesel Only)",
    subtitle = "Excludes EVs and PHEVs to show internal combustion progress",
    x = "Model Year",
    y = "Average Combined MPG"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold")
  )

# Display plots
print(plot1)
print(plot2)
print(plot3)
print(plot4)
