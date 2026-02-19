#Bar Chart:
x <- c(40, 30, 20, 10)
names(x) <- c("Red", "Blue", "Green", "Brown")
mycolors <- c("red", "blue", "green", "brown")

barplot(x,
col = mycolors,
main = "Color Preference Count",
xlab = "Color Category",
ylab = "Frequency",
border = NA) # Removes the black outline for a modern look

#Pie Chart:
mypie <- c(40, 30, 20, 10)
mycolors <- c("firebrick1", "dodgerblue2", "forestgreen", "chocolate4")


pie(mypie,
labels = c("40%", "30%", "20%", "10%"), # Custom labels
col = mycolors,
main = "Market Share Distribution", # Main title
border = "white") # Cleaner look

#Histogram:
ages <- c(22, 25, 27, 28, 30, 32, 33, 35, 36, 38,
          40, 41, 42, 45, 47, 48, 50, 52, 55, 60)

# Histogram
hist(ages,
     col = "darkgray",
     border = "white",
     main = "Age Distribution of Employees",
     xlab = "Age (years)",
     ylab = "Number of Employees",
     breaks = 10)


ages_f <- c(22, 27, 30, 33, 36, 40, 42, 47, 50, 55)
ages_m <- c(25, 28, 32, 35, 38, 41, 45, 48, 52, 60)

# Boxplot
boxplot(ages_f, ages_m,
        names = c("Female", "Male"),
        col = c("#FFB6C1", "#ADD8E6"),
        main = "Age Distribution by Gender",
        xlab = "Gender",
        ylab = "Age (years)",
        ylim = c(20, 65))
