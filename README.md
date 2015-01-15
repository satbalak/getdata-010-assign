# Cleaning Data collected from Galaxy S II

## Overview of the Source Data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The data is available for download from 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Final Output structure
The final desired output is a data file containing the following columns:
1. subject - A subject identifier with values 1 to 30
2. activity - One of the values - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
3. variable - More information below
4. XYZ_dimension - Will contain X, Y, Z to indicate the triaxial dimension. Will be blank for Magnitudes
5. mean - average mean value of this variable for this subject and activity and dimension
5. std - average std deviation value of this variable for this subject and activity and dimension