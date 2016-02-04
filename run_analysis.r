activity.Label <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Activity.ID", "Activity.Name"));
feature <- read.table("./UCI HAR Dataset/features.txt", sep = "")
## Loading test data sets
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "")
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", col.names = "Activity.ID")
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")

## naming the columns of test.x
colnames(test.x) <- unlist(feature[, 2])
## binding test x and y in one dataset
test.xy <- cbind( test.y, test.x)
## adding Activity labels on test.xy
test.complete <- cbind(test.subject, test.xy)
test.complete <- merge(activity.Label, test.complete, by = "Activity.ID")


## Load train data sets
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt", sep ="", col.names = "Activity.ID")
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
## Name the colums of Train.x
colnames(train.x) <- unlist(feature[, 2])
## bind train x and y in one dataset
train.xy <- cbind(train.y, train.x)
## add Activity Labels on Train.xy
train.complete <- cbind(train.subject, train.xy)
train.complete <- merge(activity.Label, train.complete, by="Activity.ID")

##Combining the test and training sets
Complete.Set <- rbind(train.complete, test.complete)

## Extract the Mean and Standard deviation on the result set on Complete.set to be tidy data set
Extracted.set <- select(Complete.Set, Subject, Activity.ID, Activity.Name, matches("Mean"), matches("std"))

## Extract tidy data set for average on each variable. 
Tidy.dataSet <- select(Complete.Set, Subject, Activity.ID, Activity.Name, -Activity.ID, matches("Mean")) %>%
                group_by(Subject, Activity.Name) %>% 
                summarise_each(funs(mean))
## Write tidy data set in a file. 
write.table(Tidy.dataSet, file = "./tidy_dataSet.csv", sep = ",", row.names = FALSE)
