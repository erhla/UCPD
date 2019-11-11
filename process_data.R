library(tidyverse)

folder_ls <- c("incident/", "interview/", "traffic/")


for (folder in folder_ls){
  files <- list.files(folder)
  master_df <- data.frame()
  for (cur_file in files){
    cur_df <- read_csv(paste0(folder, cur_file)) %>% select(-X1)
    master_df <- rbind(master_df, cur_df)
  }
  master_df <- master_df[complete.cases(master_df),]
  write_csv(master_df, paste0(folder))
}


