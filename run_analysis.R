

## Read datasets
features <- read.csv("UCI HAR Dataset/features.txt", sep = "", header = FALSE)[2]
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
testSet <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
trainSet <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
testMoves <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep = "", header = FALSE)
trainMoves <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep = "", header = FALSE)
testPerson <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
trainPerson <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)

## Merges the training and the test sets to create one data set.
## Creates 3 merged datasets : data, person and movement
mergedSet <- rbind(testSet,trainSet)    
mergedMoves <- rbind(testMoves, trainMoves)
mergedPerson <- rbind(testPerson, trainPerson)

## Label the data set with descriptive variable names
names(mergedSet) <- features[ ,1]

## Extracts only the measurements on the mean and standard deviation for each measurement
mergedSet <- mergedSet[ grepl("std|mean", names(mergedSet), ignore.case = TRUE) ]

## Descriptive activity names to name the activities in the data set
mergedMoves <- merge(mergedMoves, activities, by.x = "V1", by.y = "V1")[2]
mergedSet <- cbind(mergedPerson, mergedMoves, mergedSet)
names(mergedSet)[1:2] <- c("PersonID", "Activities")

## Tidy data set with the average of each variable for each activity and each subject
tidy_dataset <- group_by(mergedSet, PersonID, Activities) %>% summarise_each(funs(mean))

## Write tidy dataset
write.table(tidy_dataset, file = "tidyDataset.csv", row.names = FALSE)