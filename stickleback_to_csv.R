library(rstickleback)
library(tidyverse)
c(lunge_sensors, lunge_events) %<-% load_lunges()

sensors_df <- as.data.frame(lunge_sensors)
events_df <- as.data.frame(lunge_events)

dir.create("data")
dir.create("data/sensors")
dir.create("data/events")

write_sensors <- function(df) {
  deployid <- df$deployid[1]
  file_path <- sprintf("data/sensors/%s.csv", deployid)
  df %>%
    select(-deployid) %>%
    rename(timestamp_utc = datetime) %>%
    write_csv(file_path)
}

write_events <- function(df) {
  deployid <- df$deployid[1]
  file_path <- sprintf("data/events/%s.csv", deployid)
  df %>%
    select(-deployid) %>%
    rename(lunge = datetime) %>%
    write_csv(file_path)
}

sensors_df %>%
  group_split(deployid) %>%
  walk(write_sensors)

events_df %>%
  group_split(deployid) %>%
  walk(write_events)

zip("bluewhaledata.zip", "data/")


