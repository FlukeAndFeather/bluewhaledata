library(rstickleback)
library(tidyverse)

# Read sample data and convert to tabular form
c(lunge_sensors, lunge_events) %<-% load_lunges()
sensors_df <- as.data.frame(lunge_sensors)
events_df <- as.data.frame(lunge_events)

# Create folder structure, removing prior artifacts if applicable
if (file.exists("bluewhaledata.zip")) file.remove("bluewhaledata.zip")
if (dir.exists("data")) unlink("data", recursive = TRUE)
dir.create("data")
dir.create("data/sensors")
dir.create("data/events")

# Write sensor and event data as CSVs
write_sensors <- function(df) {
  deployid <- df$deployid[1]
  file_path <- sprintf("data/sensors/%s_sensors.csv", deployid)
  df %>%
    select(-deployid) %>%
    rename(timestamp_utc = datetime) %>%
    write_csv(file_path)
}
write_events <- function(df) {
  deployid <- df$deployid[1]
  file_path <- sprintf("data/events/%s_events.csv", deployid)
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

# Zip data and remove intermediary files
zip("bluewhaledata.zip", "data/")
unlink("data", recursive = TRUE)
