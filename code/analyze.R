library(lubridate)
library(tidyverse)
#analyze traffic
traffic <- read_csv("traffic.csv")
traffic <- traffic %>% 
  mutate(Date = mdy_hm(Date))

#recode ambiguous values
traffic <- traffic %>% 
  mutate(Disposition = case_when(str_detect(tolower(Disposition), "arrest") ~ "Arrest",
                                 str_detect(tolower(Disposition), "citation") ~ "Citation",
                                 str_detect(tolower(Disposition), "warning") ~ "Warning"))
traffic <- traffic %>% 
  mutate(Gender = case_when(str_detect(tolower(Gender), "female") ~ "Female",
                            str_detect(tolower(Gender), "male") ~ "Male"))
traffic <- traffic %>% 
  mutate(Search = case_when(str_detect(tolower(Search), "no") ~ "No",
                            str_detect(tolower(Search), "yes") ~ "Yes"))

traffic <- traffic %>% 
  mutate(Race = case_when(str_detect(tolower(Race), "african") ~ "African American",
                          str_detect(tolower(Race), "native") ~ "NHPI or Indian",
                          str_detect(tolower(Race), "caucasian") ~ "Caucasian",
                          str_detect(tolower(Race), "asian") ~ "Asian",
                          str_detect(tolower(Race), "hispanic") ~ "Hispanic" ))

traffic <- traffic %>% 
  mutate(`IDOT Classification` = case_when(str_detect(tolower(`IDOT Classification`), "follow") ~ "follow too close",
                          str_detect(tolower(`IDOT Classification`), "license") ~ "license plate/registration",
                          str_detect(tolower(`IDOT Classification`), "moving") ~ "moving violation",
                          str_detect(tolower(`IDOT Classification`), "signal") ~ "Traffic Sign/Signal",
                          str_detect(tolower(`IDOT Classification`), "seat") ~ "seatbelt",
                          str_detect(tolower(`IDOT Classification`), "speed") ~ "speed",
                          TRUE ~ `IDOT Classification`))
write_csv(traffic, "traffic_cleaned.csv")

