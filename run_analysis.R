# Getting and Cleaning Data run_analysis.R Script for cleaning data
#Load required packages
library(dplyr)
# Read test files into test variables
#Set WD to test files location
setwd('~/Coursera/UCI HAR Dataset/test')
test1 <- read.table("subject_test.txt", header = FALSE)
test2 <- read.table("X_test.txt", header = FALSE)
test3 <- read.table("y_test.txt", header = FALSE)
#Read train files into train variables
#Set WD to Train files location
setwd('~/Coursera/UCI HAR Dataset/train')
train1 <- read.table("subject_train.txt", header = FALSE)
train2 <- read.table("X_train.txt", header = FALSE)
train3 <- read.table("y_train.txt", header = FALSE)
#Read features and labels files
#Set WD to UCI HAR Dataset
setwd('~/Coursera/UCI HAR Dataset')
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

#Analysis of Training Data
colnames(activity_labels) <- c("V1", "Activity")

#Combine y_train and activity_labels
subj <- rename(train1, subject = V1)
merge1 <- cbind(train3, subj)
mergeTrain <- merge(merge1, activity_labels, by = ("V1"))

#Setting feature names to X_train df
colnames(train2) <- features[,2]

#binding y_train, activity_labels and X_train
mergeTrain1 <- cbind(mergeTrain, train2)

# Resolve Duplicate Column name: error
mergeTrain2 <- mergeTrain1[, -1]

#reduce to only columns with mean and std data
mergeTrain3 <- select(mergeTrain2, subject, Activity, 
                      contains("mean"), contains("std"))

#repeat above steps for the test data

#combine y_test activity_labels
subj1 <- rename(test1, subject = V1)
merge2 <- cbind(test3, subj1)
mergeTest <- merge(merge2, activity_labels, by = ("V1"))

#Setting feature names to X_test df
colnames(test2) <- features[,2]

#binding y_train, activity_labels and X_train
mergeTest1 <- cbind(mergeTest, test2)

# Resolve Duplicate Column name: error
mergeTest2 <- mergeTest1[, -1]

#reduce to only columns with mean and std data
mergeTest3 <- select(mergeTest2, subject, Activity, 
                      contains("mean"), contains("std"))

#Bring Train and Test data together
finalMerge <- rbind(mergeTrain3, mergeTest3)

# Separate Summary Report with averages

finalReport <- (group_by(finalMerge, subject, Activity) %>% 
                        summarize_each(funs(mean)))
finalReport


        