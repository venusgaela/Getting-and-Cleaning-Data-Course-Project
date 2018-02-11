# Getting and Cleaning Data Course Project - Venus Marie Gaela
# The following contains the code for the course project
# I put notes/comments to present the step-by-step procedure I did for the project

# Downloading the data for the project and unzipping

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Instruction 1: Merging the training and the test sets to create one data set

# Reading the files

# 1. Reading trainings tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# 2. Reading testing tables
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# 3. Reading feature vector
features <- read.table('./data/UCI HAR Dataset/features.txt')

# 4. Reading activity labels
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')


# Assigning column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Merging data into one set
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)


# Instruction 2: Extracting only the measurements on the mean and
# standard deviation for each measurement

# Reading column names
colNames <- colnames(setAllInOne)

# Creating vector for defining ID, mean and standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Making nessesary subset from setAllInOne
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


# Instruction 3: Using descriptive activity names to name 
# the activities in the data set
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)


# Instruction 4: Appropriately labels the data set with descriptive variable names
# Columns names already set in part 1


# Instruction 5: From the data set in step 4, creating a second, independent tidy data set 
# with the average of each variable for each activity and each subject

# Making second tidy data set
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# Writing second tidy data set in txt file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)

