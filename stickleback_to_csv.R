library(rstickleback)
library(tidyverse)
c(lunge_sensors, lunge_events) %<-% load_lunges()

sensors_df <- as.data.frame(lunge_sensors)
events_df <- as.data.frame(lunge_events)

write_deployment <- function(df) {
  deployid <- df$deployid[1]
  file_path <- sprintf("csv/%s.csv", deployid)
  df %>%
    select(-deployid) %>%
    write_csv(file_path)
}

sensors_df %>%
  group_split(deployid) %>%
  walk(write_deployment)

