# Define Data Frame Loader Function # ----
library(tidyverse)
load_main_df <- function() {
  colnames <- c("age", "sex", "cp", "testbps", "chol", "fbs", "restecg", "thalach",
                "exang", "oldpeak", "slope", "ca", "thal", "predicted")
  
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
  return(heart_disease_data)
}

# Load Main Data Frame # ----
heart_disease_data <- load_main_df()

# See Summary of All Columns # ----
summary(heart_disease_data)

# Make Histogram plot # ----
library(ggplot2)
ggplot(heart_disease_data, aes(x = chol)) + 
  geom_histogram() +
  facet_grid(rows = vars(region))



