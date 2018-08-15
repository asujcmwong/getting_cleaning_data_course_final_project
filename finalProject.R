
library(data.table)

#Download data for the project
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/cleaningDataProject.zip")

#unzip files 
unzip("./data/cleaningDataProject.zip", files = NULL, exdir="./data")


# Read in data for training and test
xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")



xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")




#name the activities in the data set
names(xTest) = features
names(xTrain) = features





# bind test data 
testData =  cbind(subjectTest, yTest, xTest)
# bind traning data
trainData = cbind(subjectTrain, yTrain, xTrain)


# Extract only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./data/UCI HAR Dataset/features.txt")[,2]
extract_features <- grepl("mean|std", features)
testData = testData[,extract_features]
trainData = trainData[,extract_features]

# Merge the training and the test sets to create one data set.
combinedData = rbind(testData, trainData)
 


#label the variable names
names(combinedData)[1:3] <- c("Subject", "Activity_ID", "Activity_Label")
 

idLabels   = c("Subject", "Activity_ID", "Activity_Label")
dataLabels = setdiff(colnames(combinedData), idLabels)
meltData      = melt(combinedData, id = idLabels, measure.vars = dataLabels)

# Apply mean function to dataset using dcast function
tidyData   = dcast(meltData, Subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./data/tidyData.txt")

str(tidyData)

