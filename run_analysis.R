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
    

    ## read the X_test.txt data
    readIn <- read.table("X_test.txt")
    readIn <- rbind(readIn, read.table("X_train.txt"))
    colnames(readIn) <- featv
    readIn <- data.table(readIn)
    ## select only those columns containing "mean", exclude meanFreq
    readMean <- readIn %>% select(contains("mean", ignore.case = FALSE)) %>%
                    select(-contains("meanfreq"))
    readStd <- select(readIn, contains("std"))
    
    
    ## read the y_test.txt data
    y <- read.table("y_test.txt")
    y <- rbind(y, read.table("y_train.txt"))
    a <- merge(actLab, y) 
    act <- data.frame(a[,2])
    colnames(act) <- c("activity")
    
    ## read the subject data
    sub <- read.table("subject_test.txt")
    sub <- rbind(sub, read.table("subject_train.txt"))
    colnames(sub) <- c("subject")
    
    
    read <- cbind(sub,act,readMean, readStd)
    read <- data.table(read)
    
    #td <- gather(read, signal, reading, -subject, -activity)
    #td_grp <- group_by(td, subject, activity, signal)
    #td1 <- summarize(td_grp, avg_reading = mean(reading))
    
    td <- read %>% gather(variable, reading, -subject, -activity) %>%
                group_by(subject, activity, variable) %>%
                summarize(avg_reading = mean(reading)) %>%
                arrange(subject, activity)
    
    td1 <- separate(td, variable, into=c("variable","mean_std","XYZ_dimension"))
    head(td1)
    write.table(td1, file="output.txt")

}


