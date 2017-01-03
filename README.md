# GettingandCleaningData

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.You will be required to submit:
>
1. a tidy data set as described below
2. a link to a Github repository with your script for performing the analysis
3. codeBook.md that describes the variables, the data, and any work that you performed to clean up the data 
4. README.md that explains how all of the scripts work and how they are connected.  
>
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
> 
> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

> Here are the data for the project: 

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
> 
> You should create one R script called run_analysis.R that does the following. 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set.
> 4. Appropriately labels the data set with descriptive activity names.
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
> 
> Good luck!



# Code explanations

>
First we read all datasets. Features describes the column names used on the feature vector (in the training and test sets). Note that we only need the second column of feature (first column is just the row index).
We use the read.csv function with the sep option set to "" as file format is separated like that and header = FALSE as data start on the first row
 
```R 
   ## Read datasets
features <- read.csv("UCI HAR Dataset/features.txt", sep = "", header = FALSE)[2]
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
testSet <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
trainSet <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
testMoves <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep = "", header = FALSE)
trainMoves <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep = "", header = FALSE)
testPerson <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
trainPerson <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
```


Then we use the rbind function to merge the data, person and movement datasets.


```R
   ## Merges the training and the test sets to create one data set.
## Creates 3 merged datasets : data, person and movement
mergedSet <- rbind(testSet,trainSet)    
mergedMoves <- rbind(testMoves, trainMoves)
mergedPerson <- rbind(testPerson, trainPerson)        
```


We give names to the columns of mergedSet
 by using the data in features

```R
   ## Label the data set with descriptive variable names
names(mergedSet) <- features[ ,1]
```


We use the grepl function to find the columns with mean and standard deviation in the name. We subset the mergedSet by selcting those columns


```R
   ## Extracts only the measurements on the mean and standard deviation for each measurement
mergedSet <- mergedSet[ grepl("std|mean", names(mergedSet), ignore.case = TRUE) ] 
```

We merge the movement data with activities labels in order to have descriptive activity names to name the activities in the data set. We then add 2 new columns (PersonID and Activities) to the main dataset and give names to those new columns.
```R
   ## Descriptive activity names to name the activities in the data set
mergedMoves <- merge(mergedMoves, activities, by.x = "V1", by.y = "V1")[2]
mergedSet <- cbind(mergedPerson, mergedMoves, mergedSet)
names(mergedSet)[1:2] <- c("PersonID", "Activities") 
```
Creating a new dataset with the average of each variable for each activity and each subject
```R ## Tidy data set with the average of each variable for each activity and each subject
tidy_dataset <- group_by(mergedSet, PersonID, Activities) %>% summarise_each(funs(mean))
```
Write the tidy dataset to a csv file
```R
   ## Write tidy dataset
write.table(tidy_dataset, file = "tidyDataset.csv", row.names = FALSE)
```            
