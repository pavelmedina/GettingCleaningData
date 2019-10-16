

setwd("/media/pavel/seagate-pavel/Documents/coursera/")

train <- read.csv(file = "UCI HAR Dataset/train/X_train.txt", sep = " ")
head(train)

train <- read_table2(file = "UCI HAR Dataset/train/X_train.txt", col_names = F)
train_labels <- read_table2(file = "UCI HAR Dataset/train/y_train.txt", col_names = F)

test <- read_table2(file = "UCI HAR Dataset/test/X_test.txt", col_names = F)
test_labels <- read_csv2(file = "UCI HAR Dataset/test/y_test.txt", col_names = F)

table <- rbind(train, test) 



