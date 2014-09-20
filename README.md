CleaningDataProject
===================

run_analysis.R script is created as part of student project for Coursera
course, 'Getting and Cleaning Data'.

This R script works with dataset that needs to be downloaded from the following location:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
The downloaded file, extracts to a directory "UCI HAR Dataset". This R script should be
copied to "UCI HAR Dataset" and working directory changed to this directory. When this
script is executed, it does the following to meet the requirements of the class project.
 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 3. Uses descriptive activity names to name the activities in the data set.
 4. Appropriately labels the data set with descriptive variable names. 
 5. From the data set in step 4, creates a second, independent tidy data set with the average
    of each variable for each activity and each subject.
	
Steps run the script
====================
1. Download the zip file mentioned above.
2. Extract files from the zip file in any directory. Top level extracted directory is 'UCI HAR Dataset'.
3. Copy the script, 'run_analysis.R' to the directory 'UCI HAR Dataset'.
4. Set working directory for R shell to 'UCI HAR Dataset' directory.
5. Install R packages 'dplyr' and 'tidyr' if not already installed.
6. Run the script by using 'source()' command. The script prints informative messages to the standard output as it progresses.

Output from the script
======================
1. Creates 'merged' directory under 'HCI HAR Dataset' directory.
2. Creates 'Inertial Signals' directory under 'merged directory.
3. Creates files, 'y.txt', 'X.txt' and 'subject.txt' in the 'merged' directory. These files
   contain merged data sets from data set files in 'test' and 'train' directories.
4. Creates files in 'merged/Inertial Signals' directory that contains merged data sets from
   directories with similar names in 'test' and 'train' directories.   
5. To meet the requirements of the project, three new files, 'activity.txt' (requirement # 3),
   'activity_measurements.txt' (requirements # 2,3,4) and 'activity_measure_mean.txt' (requirement # 5)
   are created in the 'merged' directory.
   
How the script works
=====================
1. The script first loads the libraries 'dplyr' and 'tidyr'. Functions from both these
   libraries are used in the code.
2. It verifies that all the relevant files exist in the proper location with respect to
   working directory. It checks the file in the top directory and then loops through the
   directories, 'test' and 'train' to ascertain that no files are missing [functions used: file.exists(), any()].
3. Create 'merged' and 'merged/Inertial Signals' if they don't exist [functions used: file.exists(), dir.create()].
4. Loop through each 'file' stored in 'files' list and create names for corresponding file in 'test' and 'train'
   directories. Read the files from 'test' and 'train' directories as data frame, merge them and then write
   the merged data set to 'file' in 'merged' directory. Delete objects created for merging.
   [functions used: read.table(), rbind(), write.table(), rm()].
5. Read 'activity_label.txt' and 'merged/y.txt'. Change the column value for data set from y.txt to activity label name.
   Change column name for the data set to 'activity'. Write the data set to a file using descriptive file name,
   'merged/activity.txt'. [functions used: names(), read.table(), write.table()]
6. Read data set from features.txt and then subset the data set to contain only the rows that have
   strings that contain either,"-main()" or "-std()' The first column of the 'sub-set' data set is saved to 'cols'
   and the second column is saved to 'colNames'.
7. Use 'cols' to select columns from data set read from 'X.txt' (selects 66 out total 561 columns are selected).
   'colNames' is used to give descriptive names to the variables (columns) in the 'X' data set. [function used: gsub()]
8. Save the resulting data set to a file with descriptive name, 'merged/activity_measurements.txt'.
9. Read single column data set 'subject' from 'subject.txt'. Add 'subject' and 'activity' (from step 5) columns to the
   data set. [function used: cbind()]
10. Make wide table data set to narrow and long data set using 'gather'. The 66 variables instead of representing
    column names become value of column 'feature'. [function used: gather]
11. Aggregate the information in the data set to have single mean for each subject, for each activity and each feature.
    The number of rows in the aggregated data set decreases to 11880 and number of columns remains the same as in
	the previous step. [function used: aggregate()]
12. Arrange the results obtained from the previous step to sort first by subject, then activity and finally by feature name.
    [function used: arrange()]
13. Write the data set obtained from the previous step to a file called, 'merged/activity_measure_mean.txt'.
14. The running of script concludes.
   
