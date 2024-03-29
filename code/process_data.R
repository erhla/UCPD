library(tidyverse)
library(lubridate)

folder_ls <- c("incident/", "interview/", "traffic/")


for (folder in folder_ls){
  files <- list.files(folder)
  master_df <- data.frame()
  for (cur_file in files){
    cur_df <- read_csv(paste0(folder, cur_file)) %>% select(-...1)
    master_df <- rbind(master_df, cur_df)
  }
  master_df <- master_df[complete.cases(master_df),]
  write_csv(master_df, paste0("files/", substr(folder, 1, nchar(folder) - 1), ".csv"))
}

#traffic
traffic <- read_csv("files/traffic.csv")
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
  mutate(`IDOT Classification` = case_when(str_detect(tolower(`IDOT Classification`), "follow") ~ "moving violation",
                                           str_detect(tolower(`IDOT Classification`), "license") ~ "license plate/registration",
                                           str_detect(tolower(`IDOT Classification`), "moving") ~ "moving violation",
                                           str_detect(tolower(`IDOT Classification`), "signal") ~ "Traffic Sign/Signal",
                                           str_detect(tolower(`IDOT Classification`), "seat") ~ "Equipment",
                                           str_detect(tolower(`IDOT Classification`), "speed") ~ "speed",
                                           str_detect(tolower(`IDOT Classification`), "lane") ~ "Lane Violation",
                                           str_detect(tolower(`IDOT Classification`), "redlight") ~ "Traffic Sign/Signal",
                                           str_detect(tolower(`IDOT Classification`), "follow") ~ "moving violation",
                                           TRUE ~ `IDOT Classification`))
write_csv(traffic, "files/traffic_cleaned.csv")

#incident
incident <- read_csv("files/incident.csv")
incident <- incident %>% 
  mutate(Occured = mdy(gsub(" .*$", "", incident$Occured)),
         Outcome = case_when(str_detect(tolower(Disposition), "arrest") ~ "arrested",
                             str_detect(tolower(Disposition), "cpd") ~ "cpd",
                             str_detect(tolower(Disposition), "open") ~ "open",
                             str_detect(tolower(Disposition), "referred") ~ "referred",
                             str_detect(tolower(Disposition), "unfounded") ~ "unfounded",
                             str_detect(tolower(Disposition), "void") ~ "void",
                             str_detect(tolower(Disposition), "cleared") ~ "cleared",
                             str_detect(tolower(Disposition), "closed") ~ "closed",
                             TRUE ~ "referred")
         )
incident <- incident %>% 
  mutate(Date = case_when(str_detect(tolower(Date), "theft") ~ "Theft",
                          str_detect(tolower(Date), "information") ~ "Information",
                          str_detect(tolower(Date), "found") ~ "Found Property",
                          str_detect(tolower(Date), "lost") ~ "Lost Property",
                          str_detect(tolower(Date), "liquor") ~ "Liquor Law Violation",
                          str_detect(tolower(Date), "medical") ~ "Medical",
                          str_detect(tolower(Date), "mental") ~ "Mental Health",
                          str_detect(tolower(Date), "battery") ~ "Battery",
                          str_detect(tolower(Date), "injured") ~ "Injury",
                          str_detect(tolower(Date), "traffic") ~ "Traffic Incident",
                          str_detect(tolower(Date), "trespass") ~ "Trespass",
                          str_detect(tolower(Date), "burglary") ~ "Burglary",
                          str_detect(tolower(Date), "assault") ~ "Assault",
                          str_detect(tolower(Date), "damage") ~ "Damage to Property",
                          str_detect(tolower(Date), "robbery") ~ "Robbery",
                          str_detect(tolower(Date), "weapon") ~ "Weapon Incident",
                          str_detect(tolower(Date), "fire") ~ "Fire",
                          str_detect(tolower(Date), "obstruct") ~ "Obstruction",
                          str_detect(tolower(Date), "reck") ~ "Reckless Action",
                          str_detect(tolower(Date), "suspic") ~ "Suspicious Action",
                          str_detect(tolower(Date), "decept") ~ "Deceptive Practice",
                          str_detect(tolower(Date), "assist") ~ "Assist Other Agency",
                          str_detect(tolower(Date), "arrest") ~ "Arrest",
                          str_detect(tolower(Date), "stalk") ~ "Stalking",
                          str_detect(tolower(Date), "harass") ~ "Harassment",
                          
                          
                          
                          
                                           TRUE ~ Date))

write_csv(incident, "files/incident_cleaned.csv")


#interview
interview <- read_csv("files/interview.csv")
interview <- interview %>% 
  mutate(Date = mdy_hm(Date))

interview <- interview %>%
  mutate(Disposition = case_when(str_detect(tolower(Disposition), "arrest") ~ "arrested",
                                 str_detect(tolower(Disposition), "released") ~ "released",
                                 str_detect(tolower(Disposition), "referred") ~ "referred",
                                 TRUE ~ "Name Checked/Other"))

interview <- interview %>% 
  mutate(Gender = case_when(str_detect(tolower(Gender), "female") ~ "Female",
                            str_detect(tolower(Gender), "male") ~ "Male"))
interview <- interview %>% 
  mutate(`Initiated By` = case_when(
    str_detect(tolower(`Initiated By`), "citizen") ~ "citizen",
    str_detect(tolower(`Initiated By`), "ucpd") ~ "UCPD",
    TRUE ~ "citizen"))

interview <- interview %>% 
  mutate(Race = case_when(str_detect(tolower(Race), "african") ~ "African American",
                          str_detect(tolower(Race), "native") ~ "NHPI or Indian",
                          str_detect(tolower(Race), "caucasian") ~ "Caucasian",
                          str_detect(tolower(Race), "asian") ~ "Asian",
                          str_detect(tolower(Race), "hispanic") ~ "Hispanic",
                          TRUE ~ "other"))
interview <- interview %>% 
  mutate(Search = case_when(str_detect(tolower(Search), "no") ~ "No",
                            str_detect(tolower(Search), "yes") ~ "Yes"))
write_csv(interview, "files/interview_cleaned.csv")
