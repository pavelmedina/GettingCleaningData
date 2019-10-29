
library(dplyr)

rm(list = ls())
setwd("/media/pavel/seagate-pavel/Documents/coursera/UCI HAR Dataset/")

train <- read.table(file = "train/X_train.txt", header = F)
test <- read.table(file = "test/X_test.txt", header = F)

train_labels <- read.table(file = "train/y_train.txt", 
                           header = F, 
                           col.names = "label")
test_labels <- read.table(file = "test/y_test.txt", 
                          header = F, 
                          col.names = "label")

features <- read.table(file = "features.txt", header = F, 
                       colClasses = c("numeric","character"),
                       col.names = c("num", "feature"))

activity <- read.table(file = "activity_labels.txt", 
                       header = F, 
                       colClasses = c("numeric", "character"), 
                       col.names = c("num", "activity"))

subject_train <- read.table(file = "train/subject_train.txt", 
                            header = F,
                            col.names = "subject")
subject_test <- read.table(file = "test/subject_test.txt", 
                           header = F,
                           col.names = 'subject')


#Step 1: Merges the training and the test sets to create one data set.
train_test <- rbind(train, test) 
subject <- rbind(subject_train, subject_test)
labels <- rbind(train_labels, test_labels)
set <- cbind(subject, labels, train_test)

#Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement.
names(set)[3:dim(set)[2]] <- features$feature
set_mean_sd <- set[,c(1,2,grep(pattern = "mean|std", x = names(set), ignore.case = T))]

#Step 3: Uses descriptive activity names to name the activities in the data set
set_mean_sd$label <- activity[set_mean_sd$label, "activity"]

#Step 4: Appropriately labels the data set with descriptive variable names.
names(set_mean_sd) <- gsub(pattern = "\\(|\\)", 
                           replacement = "", 
                           x = names(set_mean_sd))

#Step 5: From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.

newtable <- group_by(.data = set_mean_sd,
                     subject,
                     label) %>%
  dplyr::summarise_at(.vars = 3:dim(set_mean_sd)[2], 
                      .funs = mean)







