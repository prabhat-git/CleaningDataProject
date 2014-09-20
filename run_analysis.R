# Getting and Cleaning Data - Project
# File run_analysis.R
# 
# This R script works with dataset that needs to be downloaded from the following location:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# The downloaded file, extracts to a directory "UCI HAR Dataset". This R script should be
# copied to "UCI HAR Dataset" and working directory changed to this directory. When this
# script is executed, it does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#    of each variable for each activity and each subject.

library(dplyr)
library(tidyr)

setwd(".")
# Check if the working directory is correct.
print("Checking if all required files exist in the working directory.")
files = c("./activity_labels.txt", "./features.txt", "./features_info.txt", "README.txt", "./run_analysis.R")
if (any(!file.exists(files))) {
    print ("WARNING: Working directory may be incorrect because data files are missing.")
}
files = c("subject.txt", "X.txt", "y.txt", "Inertial Signals/body_acc_x.txt", "Inertial Signals/body_acc_y.txt", "Inertial Signals/body_acc_z.txt", "Inertial Signals/body_gyro_x.txt", "Inertial Signals/body_gyro_y.txt", "Inertial Signals/body_gyro_z.txt", "Inertial Signals/total_acc_x.txt", "Inertial Signals/total_acc_y.txt", "Inertial Signals/total_acc_z.txt")
for (ctg in c("test", "train")) {
  for (file in files) {
    file <- sub(".txt", paste("_",ctg,".txt", sep=""), file)
    file <- paste(".", ctg, file, sep="/")
    if (!file.exists(file)) {
       print (paste("'", file, "'", " file is missing.", sep=""))
    }
  }
}
print("Working directory is correct.")
print("Creating 'merged' directory to place merged data sets.")
# Create a directory to store merged training and test data.
if (!file.exists("./merged")) {
    dir.create("./merged")
}
if (!file.exists("./merged/Inertial Signals")) {
    dir.create("./merged/Inertial Signals")
}

# Merge 'train' and 'test' data sets.

for (file in files) {
  fileTest <- paste("./test", sub(".txt", "_test.txt", file), sep="/")
  fileTrain <- paste("./train", sub(".txt", "_train.txt", file), sep="/")
  file <- paste("./merged", file, sep="/")
  print(paste("Merging", fileTrain, "and", fileTest, "and saving to", file, sep=" "))
  dataTest <- read.table(fileTest)
  dataTrain <- read.table(fileTrain)
  dataMerged <- rbind(dataTrain, dataTest)
  write.table(dataMerged, file)
#  print(paste(nrow(dataTrain), nrow(dataTest), nrow(dataMerged), sep="  "))
  rm(dataTest, dataTrain, dataMerged)
}

print ("Adding descriptive name to activities data set.")
actLabel <- read.table("./activity_labels.txt", stringsAsFactors=FALSE)
y <- read.table("./merged/y.txt")
y$V1 <- actLabel[y$V1, 2]
names(y) <- c("activity")
print("Saving new activities data set to file ./merged/activity.txt.")
write.table(y, "./merged/activity.txt")

# Extract only the measurements on the mean and the standard deviation for each measurement.
print("Extracting only the measurement on mean and standard deviation for each measurement.")
features <- read.table("./features.txt", stringsAsFactors=FALSE)
cols <- features[grepl("-mean\\(\\)", features$V2) | grepl("-std\\(\\)", features$V2),1]
colNames <- features[grepl("-mean\\(\\)", features$V2) | grepl("-std\\(\\)", features$V2),2]
X <- read.table("./merged/X.txt")
X <- X[, cols]
names(X) <- gsub("\\(\\)", "", colNames)
print("Saving measurement data set with only the mean and standard deviation variables with descriptive names to file ./merged/activity_measurements.txt.")
write.table(X, "./merged/activity_measurements.txt")

# Creating new tidy data set
print("Creating independent tidy dataset with the average of each variable for each activity and each subject.")
subject <- read.table("./merged/subject.txt")
names(subject) <- c("subject")
X <- cbind(subject, y, X)
myX <- gather(X, "feature", "value", -subject, -activity)
amyX <- aggregate(value~subject+activity+feature, myX, mean)
fmyX <- arrange(amyX, subject, activity, feature)
print("Saving tidy dataset to ./merged/activity_measure_mean.txt")
write.table(fmyX, "./merged/activity_measure_mean.txt.")
print ("run_analysis.R script completed!!")