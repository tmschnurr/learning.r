# at top of the script, have all packages loading in one file and then refer to it
source(here::here("R/package-loading.R")) #need here::here to say its relative to your R-project file

#object assignment
weight_kilos <- 100
#vector = string of things
c("a", "b") #character vector
c(1,2) #number vector
1:2 #in R means put things together as vector
1:10
#data.frame = series of vectors in columns (= like a spreadsheet, column = vector and data.frame = several vectors put together)
head(iris) #build in data-set iris, example for vector
colnames(iris)
str(weight_kilos) #structure of object or dataset
str(iris) #tells you its a data.frame with 150 observations of 5 variables
summary(iris) #bunch of details of mean, max, min,... of all variables in iris data.frame

lm

#make a new section = code --> new section, in outline right tab up corner can see outline
#exercise ----------------------------------------------------------
#copy&paste code from website and clean up a bit

# Object names
# Should be camel case
# DayOne
day_one
# dayone
day_one

# Should not over write existing function names
# T = TRUE, so don't name anything T
# T <- FALSE
false <- FALSE
# c is a function name already. Plus c is not descriptive
# c <- 9
number_value <- 9
# mean is a function, plus does not describe the function which is sum
# mean <- function(x) sum(x)
sum_vector <- function(x) sum(x)

# Spacing
# Commas should be in correct place
# x[,1]
# x[ ,1]
# x[ , 1]
x[, 1]
# Spaces should be in correct place
# mean (x, na.rm = TRUE)
# mean( x, na.rm = TRUE )
mean(x, na.rm = TRUE)
# function (x) {}
# function(x){}
function(x) {}
# height<-feet*12+inches
height <- feet * 12 + inches
# mean(x, na.rm=10)
mean(x, na.rm = 10)
# sqrt(x ^ 2 + y ^ 2)
sqrt(x^2 + y^2)
# df $ z
df$z
# x <- 1 : 10
x <- 1:10

# Indenting should be done after if, for, else functions
# if (y < 0 && debug)
# message("Y is negative")
if (y < 0 && debug)
  message("Y is negative")


# styler-package ----------------------------------------------------------
# Code --> reformat, will find unnecessary spaces etc.


# functions ---------------------------------------------------------------
#make as many functions as possible
#DRY do not repeat yourself! If you type sth more than 3 times, make a function for it!"
#lets create a quick function
# use fun and tab, then there is a basic setup that we just need to fill in
summing <- function(a, b) {
  add_numbers <- a + b
  return(add_numbers)
}
summing(2, 2) #then, use the function


# tidyverse-package -------------------------------------------------------
library(tidyverse) #uses ggplot,... they all follow under a common philosphy to get things done nicely
# call on top (as set-up) > in console: usethis::use_r("package-loading")

# write-read-data ---------------------------------------------------------
#write_csv and read_csv comes from tidyverse
write_csv(iris, here::here("data/iris.csv")) #saves csv files as dataset, Luke recommends csv files to you
# say take iris data-set and put here in project into data folder

#we can then access it doing:
iris_data <- read_csv(here::here("data/iris.csv"))
iris_data # you get sth called the "tibble" bit wired but only because it needs to show it on the screen in a quick and dirty way

