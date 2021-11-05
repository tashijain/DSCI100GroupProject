# Define Data Frame Loader Function # ----
library(tidyverse)
load_main_df <- function() {
  colnames <- c("age", "sex", "cp", "trestbps", "chol", "fbs", "restecg", "thalach",
                "exang", "oldpeak", "slope", "ca", "thal", "presense")
  
  heart_disease_data <- read_delim("data/reprocessed.hungarian.data", 
                               delim = " ",
                               col_names = colnames) |>
      mutate(region = factor("hungary"))
  
  path_names <- list("data/processed.cleveland.data", 
                    "data/processed.switzerland.data", 
                    "data/processed.va.data")
  factors <- list("cleveland", "switzerland", "va")

  # for every iteration in the loop, increment by 1
  i <- 1

  for (p in path_names) {

    # for every file processed, add a col that has the region name
    data_from_file <- read_csv(p, col_names = colnames, na = c("?")) |>
      mutate(region = factor(factors[i]))
    
    # add the freshly read data to the master data frame
    heart_disease_data <- rbind(heart_disease_data, data_from_file)
    
    # increment to keep track of the position in the list of files
    i<-i+1
  }
  return(select(heart_disease_data, age, trestbps, chol, thalach, oldpeak, 
                region, presense))
}

# Load Main Data Frame # ----
heart_disease_data <- load_main_df()

# See Summary of All Columns # ----
summary(heart_disease_data)

# Columns that can be selected #----
# 5 variables, choose 3 => 10 variations
# "presense" <- col to predict
picked_cols <- c("age", "trestbps", "chol", "thalach", "oldpeak")
# age: age in years 
# trestbps: resting blood pressure (in mm Hg on admission to the hospital) 
# chol: serum cholesterol in mg/dl 
# thalach: maximum heart rate achieved
# oldpeak: ST depression induced by exercise relative to rest 

# Make Histogram plot # ----
library(ggplot2)
ggplot(heart_disease_data, aes(x = chol)) + 
  geom_histogram() +
  facet_grid(rows = vars(region), cols = vars(presense))

# Make a Whisker Box Plot # ----
ggplot(heart_disease_data, aes(x = region)) + 
  geom_boxplot() + 
  facet_grid(rows = vars(trestbps, chol, thalach, oldpeak))

