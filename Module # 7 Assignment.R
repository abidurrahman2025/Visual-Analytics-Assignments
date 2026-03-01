#S3 example
# Load mtcars dataset
data(mtcars)
# Create a simple object and assign an S3 class
my_car <- list(model = "Mazda RX4", mpg = 21.0)
class(my_car) <- "car"

# Define an S3 method for the generic function print()
print.car <- function(x, ...) {
  cat("Car model:", x$model, "\n")
  cat("Miles per gallon:", x$mpg, "\n")
}

# Test the method
print(my_car)



#S4 example
# Load methods package (usually automatic)
# library(methods)

# Define an S4 class with two slots
setClass("Car",
         slots = c(model = "character", mpg = "numeric")
)

# Create an S4 object using new()
my_car_s4 <- new("Car", model = "Mazda RX4", mpg = 21.0)

# Define an S4 method for the generic show()
setMethod("show", "Car", function(object) {
  cat("Car model:", object@model, "\n")
  cat("Miles per gallon:", object@mpg, "\n")
})

# Test the method
my_car_s4