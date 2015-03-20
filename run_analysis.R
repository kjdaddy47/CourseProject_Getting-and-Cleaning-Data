install.packages("plyr")
library(plyr)

setwd("C:/Users/mkim2/Downloads/UCI HAR Dataset")

# Read in the data and merging both files into one
subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest       = read.table('./test/x_test.txt',header=FALSE)
yTest       = read.table('./test/y_test.txt',header=FALSE)

testData = cbind(yTest,subjectTest,xTest)

subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

xt <- rbind(xTrain, xTest)
y <- rbind(yTrain, yTest)
subject <- rbind(subjectTrain, subjectTest)

Data = cbind(xt,y,subject)

#Extracting only the measurements on the mean and sd for each measurements
features <- read.table("features.txt")

msdonly <- grep("-(mean|std)\\(\\)", features[, 2])

xt <- xt[, msdonly]

names(x) <- features[msdonly, 2]

#Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
y[, 1] <- activities[y[, 1], 2]
names(y) <- "activity"

# Appropriately label the data set with descriptive variable names
names(subject) <- "subject"
finaldata <- cbind(xt, y, subject)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
s <- split(finaldata,finaldata$activity)
answer <- lapply(s,function(x) colMeans(x[,1:66]))
write.table(answer, "answer.txt", row.name=FALSE)
