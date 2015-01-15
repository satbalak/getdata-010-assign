### Coursera Course : Getting and Cleaning
### Course Project done by Satya Balakrishnan in Jan 2015

run_analysis <- function (){
    
    library(dplyr)
    library(data.table)
    library(tidyr)
    ### Check if the zip file exists, if it does not exist, then download file
    if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, destfile = "./getdata_projectfiles_UCI HAR Dataset.zip")
    }
    
    ### extract the files train/X_train.txt and test/X_test.txt
    ### before extracting, check if these exists, if they do, then remove them
    ### check for the output.txt file also which this program creates
    if (file.exists("X_test.txt")){
        file.remove("X_test.txt")
    }

    if (file.exists("X_train.txt")){
        file.remove("X_train.txt")
    }
    
    if (file.exists("output.txt")){
        file.remove("output.txt")
    }
    
    f <- c( "UCI HAR Dataset/activity_labels.txt"
           ,"UCI HAR Dataset/features.txt"
           ,"UCI HAR Dataset/test/subject_test.txt"
           ,"UCI HAR Dataset/test/X_test.txt"
           ,"UCI HAR Dataset/test/y_test.txt"
           ,"UCI HAR Dataset/train/subject_train.txt"
           ,"UCI HAR Dataset/train/X_train.txt"
           ,"UCI HAR Dataset/train/y_train.txt")
           
    unzip("getdata_projectfiles_UCI HAR Dataset.zip", files = f, junkpaths=TRUE)
    
    ## read the activity labels and features
    actLab <- read.table("activity_labels.txt")
    feat <- read.table("features.txt")
    featv <- as.character(feat[,2])
    

    ## read the test and training data and merge them
    readIn <- read.table("X_test.txt")
    readIn <- rbind(readIn, read.table("X_train.txt"))
    ## set the column names of the 561 variables
    colnames(readIn) <- featv
    ## convert the data frame into data table for improving performance
    readIn <- data.table(readIn)
    
    ## 2. Extracts only the measurements on the mean and standard deviation 
    ## for each measurement. 
    ## select only those columns containing "mean", exclude meanFreq
    readMean <- readIn %>% select(contains("mean", ignore.case = FALSE)) %>%
                    select(-contains("meanfreq"))
    readStd <- select(readIn, contains("std"))
    
    
    ## read the y_test.txt data
    y <- read.table("y_test.txt")
    y <- rbind(y, read.table("y_train.txt"))
    ## 3. Uses descriptive activity names to name the activities in the data set
    a <- merge(actLab, y) 
    act <- data.frame(a[,2])
    colnames(act) <- c("activity")
    
    ## read the subject data
    sub <- read.table("subject_test.txt")
    sub <- rbind(sub, read.table("subject_train.txt"))
    colnames(sub) <- c("subject")
    
    ## create one data set containing, subject, activity and all readings
    read <- cbind(sub,act,readMean, readStd)
    read <- data.table(read)
    
    ## Now, we see that the variables are all stored as columns
    ## so we use gather and convert the variables into rows
    ## then we group by and calculate the average reading for each variable
    ## for each activity and each subject
    td <- read %>% gather(variable, reading, -subject, -activity) %>%
                group_by(subject, activity, variable) %>%
                summarize(avg_reading = mean(reading)) %>%
                arrange(subject, activity)
    
    ## The variable column actually contains variable, mean or std devn and 
    ## XYZ dimension, so separate this into 3 columns
    td1 <- separate(td, variable, into=c("variable","mean_std","XYZ_dimension"))
    
    ## write the output into a file
    write.table(td1, file="output.txt")

}


