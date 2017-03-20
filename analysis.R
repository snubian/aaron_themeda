library(tidyverse)
library(stringr)
library(raster)

rm(list = ls())

# get lonlat data
data <- read_csv("data/themeda_seed_collection.csv")

# get list of climate files
f <- list.files("~/Work/Range size/data/climate/emast_anuclim_mmn/raster/0.01/", "asc", full.names = TRUE)

for (i in seq_len(length(f))) {
  # for each climate file
  # extract climate data at lonlat points and append new column
  data <- data %>%
    dplyr::select(longitude, latitude) %>%
    extract(raster(f[i]), .) %>%
    as.data.frame %>%
    setNames(basename(f[i] %>% str_extract("bio[0-9]+_[a-z]+"))) %>%
    cbind(data, .)
}

data %>% write_csv("output/themeda_bioclim.csv")
