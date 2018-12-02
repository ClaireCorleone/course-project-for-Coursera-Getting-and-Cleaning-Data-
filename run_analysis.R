if(!file.exists("C:/Users/hp/Desktop/data")){dir.create("C:/Users/hp/Desktop/data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "C:/Users/hp/Desktop/data/Dataset.zip", method = "curl")

unzip(zipfile = "C:/Users/hp/Desktop/data/Dataset.zip", exdir = "C:/Users/hp/Desktop/data")

path_rf <- file.path("C:/Users/hp/Desktop/data", "UCI HAR Dataset")
files <- list.files(path_rf, recursive = TRUE)
files

dataActivityTest <- read.table(file.path(path.rf,"test","Y_test.txt"), head = FALSE)
dataActivityTrain <- read.table(file.path(path.rf, "train", "Y_train.txt"), head = FALSE)
dataSubjectTrain <- read.table(file.path(path.rf, "train", "subject_train.txt"), head = FALSE)
dataSubjectTest <- read.table(file.path(path.rf, "test", "subject_test.txt"), head = FALSE)
dataFeaturesTest <- read.table(file.path(path.rf, "test", "X_test.txt"), head = FALSE)
dataFeaturesTrain <- read.table(file.path(path.rf, "train", "X_train.txt"), head = FALSE)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)
names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames <- read.table(file.path(path.rf, "features.txt"), head = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
Data <- subset(Data, select = selectedNames)

activityLabels <- read.table(file.path(path.rf, "activity_labels.txt"), head = FALSE)

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

library(dplyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

library(knitr)
knit2html("codebook.Rmd")
