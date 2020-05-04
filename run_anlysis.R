library(dplyr)

filename <- "datasets.zip"

### Downloading zip file if not exists
if(!file.exists(filename)){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",filename)
}

### Unzipping zip if not already unzipped
if(!file.exists("UCI HAR Dataset")){
  unzip(filname)
}

### Loading datasets
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")



### Merging datasets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
data <- cbind(Subject, X, Y)

### Extracting mean and standard deviation only

Extracted_data <- select(data, subject, code, contains("mean"), contains("std"))

### Changing activity names to appropriate

Extracted_data$code = activities[Extracted_data$code, 2]

names(Extracted_data)[2] = "activity"
names(Extracted_data)<-gsub("Acc", "Accelerometer", names(Extracted_data))
names(Extracted_data)<-gsub("Gyro", "Gyroscope", names(Extracted_data))
names(Extracted_data)<-gsub("BodyBody", "Body", names(Extracted_data))
names(Extracted_data)<-gsub("Mag", "Magnitude", names(Extracted_data))
names(Extracted_data)<-gsub("^t", "Time", names(Extracted_data))
names(Extracted_data)<-gsub("^f", "Frequency", names(Extracted_data))
names(Extracted_data)<-gsub("tBody", "TimeBody", names(Extracted_data))
names(Extracted_data)<-gsub("-mean()", "Mean", names(Extracted_data), ignore.case = TRUE)
names(Extracted_data)<-gsub("-std()", "STD", names(Extracted_data), ignore.case = TRUE)
names(Extracted_data)<-gsub("-freq()", "Frequency", names(Extracted_data), ignore.case = TRUE)
names(Extracted_data)<-gsub("angle", "Angle", names(Extracted_data))
names(Extracted_data)<-gsub("gravity", "Gravity", names(Extracted_data))

### Writing the final Tidy dataset into a txt file

TidyData <- Extracted_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(TidyData, "FinalData.txt", row.name=FALSE)

