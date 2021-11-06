####################################
#### Analysis: MaRs-IB Accuracy ####
####################################
# Kate Nussenbaum, katenuss@gmail.com
# Last updated: 11/3/21


# This script analyzes data from the MaRs-IB task and computes
# accuracy for each participant. It saves a CSV file with two
# columns: sub_id and mars_acc.


#### load needed libraries ####
library(tidyverse)  
library(glue)       
library(magrittr)   

##### read in data #####

#define directory
mars_dir = "data/mars_data/"

# list of files
data_files <- list.files(path = mars_dir, pattern = ".csv")

# initialize data frame
data <- data.frame()

# read in data
for (i in c(1:length(data_files))){
  sub_data <- read_csv(glue("{mars_dir}{data_files[i]}")) 
  
  # compute the number of browser interactions
  num_interactions = length(str_split(tail(sub_data,1)$interactions, pattern = "\r\n")[[1]]) - 2
  sub_data$num_interactions <- num_interactions
  
  # compute number of practice trials answered correctly
  num_quiz_correct = nrow(sub_data %>% filter(sub_data$part == "practice"))
  sub_data$correct_quiz_questions <- num_quiz_correct
  
  # combine subject data into larger data frame
  data <- rbind(data, sub_data)
}

# select only the columns we care about
data %<>% 
  select(c(trial_index,
           subject_id,
           rt,
           correct)) %>%
  filter(data$part == "exp") %>%
  mutate(rt = as.numeric(rt),
         sub_id = as.factor(subject_id))

# exclude items with a response time under 250 
data %<>%
  filter(rt > 250)

# compute mars accuracy for each participant
data %<>%
  mutate(acc = case_when(correct == TRUE ~ 1,
                         correct == FALSE ~ 0)) %>%
  group_by(sub_id) %>%
  summarize(mars_acc = mean(correct, na.rm = T)) 

#save as csv
write_csv(data, 'data/other_data_files/mars_accuracy.csv')
