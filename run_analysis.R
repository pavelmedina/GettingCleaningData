
######################################################################################
############################## LOADING PACKAGE #######################################
######################################################################################
#The only external package I use for solve the assignment is dplyr, which normally is not include in R core. 
#If you have not installed this package, then you can use the following instruction: ìnstall.packages('dplyr').

library(dplyr)# load the package
rm(list = ls()) #This is a good practice for me to remove all objects in R evoiroment.


######################################################################################
############################## LOAD DATA #############################################
######################################################################################

# In only one code block I downloaded and loaded all tables needed for analysis. 
# Notice that in many cases I established the column class directly from read.table function. 
#This practice help me to avoid future class transformation.

download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "data.zip")
  unzip(zipfile = "data.zip")

train <- read.table(file = "UCI HAR Dataset/train/X_train.txt", header = F)
test <- read.table(file = "UCI HAR Dataset/test/X_test.txt", header = F)

train_labels <- read.table(file = "UCI HAR Dataset/train/y_train.txt", 
                           header = F, 
                           col.names = "label")
test_labels <- read.table(file = "UCI HAR Dataset/test/y_test.txt", 
                          header = F, 
                          col.names = "label")

features <- read.table(file = "UCI HAR Dataset/features.txt", header = F, 
                       colClasses = c("numeric","character"),
                       col.names = c("num", "feature"))

activity <- read.table(file = "UCI HAR Dataset/activity_labels.txt", 
                       header = F, 
                       colClasses = c("numeric", "character"), 
                       col.names = c("num", "activity"))

subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt", 
                            header = F,
                            col.names = "subject")
subject_test <- read.table(file = "UCI HAR Dataset/test/subject_test.txt", 
                           header = F,
                           col.names = 'subject')


######################################################################################
########Step 1: Merges the training and the test sets to create one data set. ########
######################################################################################

#For this step the rbind and cbind functions was used. 
#Merging was a very easy step because all data had ordered rows. I named this merged table like 'set' table.

train_test <- rbind(train, test) 
subject <- rbind(subject_train, subject_test)
labels <- rbind(train_labels, test_labels)
set <- cbind(subject, labels, train_test)

#################################################################################################
#Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement.
#################################################################################################

#For this step I used a grep function. 
#I used it for look at all the possible coincidences that names features had with words 'mean' and 'std'. 
#I extract indexes from this coincidences to extract the columns from the data table. 
#I named this new table like 'set_mean_sd' table.

names(set)[3:dim(set)[2]] <- features$feature
set_mean_sd <- set[,c(1,2,grep(pattern = "mean|std", 
                               x = names(set), 
                               ignore.case = T))]

#################################################################################################
#Step 3: Uses descriptive activity names to name the activities in the data set #################
#################################################################################################

#For previous table I replace the number label by name activity. 
#This procedure was very easy because activity table had a column with the row number, 
#and this number and activity description were ordered.
set_mean_sd$label <- activity[set_mean_sd$label, "activity"]

#################################################################################################
#Step 4: Appropriately labels the data set with descriptive variable names. ####################
#################################################################################################

#All columns was correctly named in step 3, 
#so the only thing I notice for this step, was that variable names had parenthesis symbols in there. 
#Then I erased this symbol from the column names.
names(set_mean_sd) <- gsub(pattern = "\\(|\\)", 
                           replacement = "", 
                           x = names(set_mean_sd))

#################################################################################################
#Step 5: From the data set in step 4, creates a second, independent tidy data set with 
#################################################################################################

#For this final step I used two functions from dplyr package, group_by and summarise_at. 
#The first function allow me to grouping the 'set_mean_sd' table by 'subject' and 'label', 
#to can apply a summarise_at function for the 'mean' calculation.

newtable <- group_by(.data = set_mean_sd,
                     subject, label) %>%
  dplyr::summarise_at(.vars = -c(1,2,3), .funs = mean)

write.csv(x = newtable, 
          file = "tidyData.csv", row.names = F)







