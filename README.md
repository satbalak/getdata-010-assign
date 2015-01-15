# Cleaning Data collected from Galaxy S II

## Overview of the Source Data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The data is available for download from 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Final Output structure
The final desired output is a data file containing the following columns:

* subject - A subject identifier with values 1 to 30
* activity - One of the values - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* variable - More information below
* XYZ_dimension - Will contain X, Y, Z to indicate the triaxial dimension. Will be blank for Magnitudes
* mean - average mean value of this variable for this subject and activity and dimension
* std - average std deviation value of this variable for this subject and activity and dimension

## How to arrive at the final output

By reading the REAME.txt and features_info.txt in the zip file, we can get the following information about the data

* The test data is stored in the test folder and the train data is stored in the train folder
* The features_info.txt gives an overview of all variables 
* features.txt contains 561 variable names
* The activity_labels.txt contains an id for each of the 6 activities
* The file "UCI HAR Dataset/test/X_test.txt" contains 2947 rows of 561 variables
* The file "UCI HAR Dataset/test/y_test.txt" contains 2947 rows of the activity id done
* The file "UCI HAR Dataset/test/subject_test.txt" contains 2947 rows of the subject id. There are 9 subjects in the test data
* In the train folder, you find the x_train, y_train and subject_train files with 7352 rows each. So, across test and train data, we have 10299 rows

### Collate the Data
In the 'test' folder, we have subject, activity and data across 3 files. We read these files into data frames and give them the right column names. To give the column names from the 561 variables in the x_test.txt, we use the features.txt data and give the right column names in the data frame.

For the Activity field, we do a "merge" of the y_test.txt into activity_labels.txt and get the actual activity name in the data frame.

Now, we cbind the 3 data frames - x_test, subject_test and y_test to get a collated data frame with the correct column names. This gives the collated data that we need to clean

### Cleaning the data
On the collated data set, we do gather, group by and summarize to capture the average of each variable for each activity and each subject. Then we arrange by subject and activity. After this, we see that the variable column actually has 3 values - variable name, mean or std and X/Y/Z dimension. So separate this into 3 columns.

After separating, we notice that it is better to have the average values of mean and std as columns. So, we use spread to do this change.

Now, we have the final data set with the columns we want as output. We write this to a file.