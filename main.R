library(tidyverse)
library(ggplot2)
library(dplyr)

# Load Main Data Frame # ----

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
  heart_disease_data<- mutate_at(heart_disease_data, vars(presense), factor)
  return(select(heart_disease_data, age, trestbps, chol, thalach, oldpeak, 
                region, presense))
}

heart_disease_data <- load_main_df()

# See Summary of All Columns # ----
head(heart_disease_data)
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


# Chol Analysis #----
# original histogram of chol distribution
ggplot(heart_disease_data, aes(x = chol)) + 
  geom_histogram(na.rm = TRUE) +
  facet_grid(rows = vars(region), cols = vars(presense))

# Manual split of ranges of cholesterol
heart_disease_data %>%
  filter(!is.na(chol)) %>%
  group_by(presense) %>%
  mutate(chol_bin = cut(chol,
                        breaks = c(-10, 90, 190, 290, 390, 490, 610),
                        right=FALSE)) %>%
  group_by(presense, chol_bin) %>%
  summarize(n = n()) %>%
  mutate(pert = 100* (n / sum(n))) %>%
  ggplot(aes(y = pert, x = presense, fill = chol_bin)) +
  geom_bar(stat = "identity", position = "stack") +
  #facet_grid(rows = vars(presense)) +
  labs(y = "percentage (%) in cholesterol range", x = "Heart Disease",
       fill = "Cholesterol Ranges")

# Density plot
ggplot(heart_disease_data, aes(names("chol"), 
                               after_stat(density),
                               fill = presense)) +
  geom_histogram(binwidth = 20) + 
  labs(y = "Density of Heart Disease Categories",
       x = "Serum Cholesterol Levels (mg/dl)",
       fill = "Heart Disease")


chol_range_table <- heart_disease_data %>%
  filter(!is.na(chol)) %>%
  group_by(presense) %>%
  mutate(chol_bin = cut_width(chol, width = 100)) %>%
  group_by(presense, chol_bin) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = chol_bin, values_from = n)


# Density Plot of All 5 Variables # ----
heart_disease_data %>%
  pivot_longer(cols = age:oldpeak, names_to= "type", values_to = "value") %>%
  ggplot(aes(x = value, after_stat(density), fill = presense)) +
  geom_histogram(bins = 10) + 
  facet_wrap(.~ type, scales = "free")

# Interval Splitter and Table # -----
library(stringr)
interval_count <- function() {
  heart_disease_count <- heart_disease_data %>%
    filter(!is.na(age)) %>%
    group_by(presense) %>%
    mutate(age = cut_interval(age, n = 5)) %>%
    count(presense, age) %>%
    mutate(type = factor("age")) %>%
    setNames(c("presense", "range", "n", "type"))
  heart_disease_count
  
  for (name in c("trestbps", "chol", "thalach", "oldpeak")) {
    heart_disease_range <- heart_disease_data %>%
      filter(!is.na(!!sym(name))) %>%
      group_by(presense) %>%
      mutate(!!sym(name) := cut_interval(!!sym(name), n = 5)) %>%
      count(presense, !!sym(name)) %>%
      mutate(type = factor(name)) %>%
      setNames(c("presense", "range", "n", "type"))
    heart_disease_range

    heart_disease_count<- rbind(heart_disease_count, heart_disease_range)
  }
  return(heart_disease_count)
}
heart_diease_split_data <- interval_count() %>%
  group_by(presense, type) %>%
  mutate(pert = n/sum(n)* 100)

# Percentage histogram #----
# Ignore, it looks ugly
ggplot(heart_disease_data, aes(x = chol)) +  
  geom_histogram(aes(y = 100*(..count..)/sum(..count..))) +
  facet_grid(rows = vars(presense), scales = "free_y")
  