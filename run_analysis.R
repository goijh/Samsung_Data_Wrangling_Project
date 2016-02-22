#The purpose of this script is to combine multiple datasets related to experiments involving the accelerometer and gyroscope of the Samsung Galaxy SII in order to more easily examine the means and standard deviations of the datasets by subject and activity.
#Datasets can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# Open dplyr and tidyr packages
library(dplyr)
library (tidyr)

#Import the test and train datasets using the import dataset feature in the environment pane of RStudio

#Combine the datasets
names(activity_labels) <- c('ActivityLabel', 'ActivityName')

subject_combined <- bind_rows(subject_test, subject_train)
names(subject_combined) <- c('subject')

x_combined <- bind_rows(X_test, X_train)
names (x_combined) <- make.names(features$V2, unique = TRUE)

y_combined <- bind_rows(y_test, y_train)
names(y_combined) <- c('ActivityLabel')

combined_datasets <- bind_cols(subject_combined, y_combined) %>%
    left_join(activity_labels) %>%
    bind_cols(x_combined)

#Optional: use the glimpse function to verify that datasets were successfully combined

#Select variables containing mean and SD for each observation
mean_std_data <- combined_datasets %>% select( -matches("mean|std"))


#Summary
summary_data <- mean_std_data %>%
  group_by(subject, ActivityName) %>%
  summarise_each(funs(mean), -one_of(c('subject', 'ActivityLabel', 'ActivityName')))

#display summary data
summary_data