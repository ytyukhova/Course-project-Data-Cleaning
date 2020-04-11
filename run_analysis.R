## This is an R script with the exact recipe of how to get from raw data to tidy data set.

## STEP 1 Merge the training and the test sets to create one data set.

## Check working directory

## TEST files loaded into R
 
## Subject ID. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. (from readme.txt)
subj_test<-read.table("./test/subject_test.txt", header = FALSE, sep = "")
## Check dimensions
dim(subj_test)

## Test labels (from readme.txt)
test_label<-read.table("./test/y_test.txt", header = FALSE, sep = "")
## Check dimensions
dim(test_label)

## Test data set
test_set<-read.table("./test/X_test.txt", header = FALSE, sep = "")
## Check dimensions and class
dim(test_set)
class(test_set$V1)

## 561 variables in test_set match 561 features in features.txt
## Read features.txt into R
features<-read.table("./features.txt", header = FALSE, sep = "")
## Check data and dimensions
head(features)
dim(features)

## Assign names to the columns in test_set
names(test_set)<-features$V2
names(test_set)

## Add "mode" variable (test/train, in this case test) 
mode<-rep("test",2947)

## EXTRA: To drop a column in the data set df=subset(data_test,select=-c(mode))

## Combine subject ID, activity labels,and mode for test data and then rename columns
data_test<-cbind(subj_test,test_label,mode)
names(data_test)<-c("subject","activity","mode")

## Combine this data_test with the renamed test_set
data_test<-cbind(data_test,test_set)
## Check part of data. Get info.
data_test[1:5,1:5]


## TRAIN files loaded into R

## Subject ID
subj_train<-read.table("./train/subject_train.txt", header = FALSE, sep = "")
dim(subj_train)

## Training labels
train_label<-read.table("./train/y_train.txt", header = FALSE, sep = "")
dim(train_label)

## Training set
train_set<-read.table("./train/X_train.txt", header = FALSE, sep = "")
dim(train_set)

## Rename train_set
names(train_set)<-features$V2

## Add "mode" variable (test/train, in this case train) 
mode<-rep("train",7352)

## Combine subject ID and activity labels for train data and then rename columns
data_train<-cbind(subj_train,train_label,mode)
names(data_train)<-c("subject","activity","mode")
## Combine this data_train with renamed train_set
data_train<-cbind(data_train,train_set)
data_train[1:5,1:5]

## Merge both data sets to create one
data<-rbind(data_test,data_train)
str(data)

## STEP 2. Extract only the measurements on the mean and standard deviation for each measurement.
## Find measurements that have mean (except meanFreq) OR std in their names. Show values
grep("mean[^meanFreq]|std",names(data),value=TRUE)
## Take only those columns from data that have mean (&except meanFreq and std in their name)
mean_std<-data[,grep("mean[^meanFreq]|std",names(data))]
names(mean_std)
## Bind subject,activity,and mode
data2<-cbind(data[,1:3],mean_std)

## STEP 3. Use descriptive activity names to name the activities in the data set
## Read activity_labels file into R
activity_labels<-read.table("./activity_labels.txt", header = FALSE, sep = "")
activity_labels

## Loops over the column & evaluates a custom function(and simplifying it). Function takes the row number and applies the
## column value.
data2$activity<-sapply(data2$activity,function(x) {activity_labels[x,2]})
data2[1:5,1:5]
  
## STEP 4. Appropriately label the data set with descriptive variable names.

names(data2)
names(data2)<-gsub("-","_",names(data2))
names(data2)<-gsub("\\()","",names(data2))
names(data2)<-gsub("tBody","timeBody",names(data2))
names(data2)<-gsub("Acc","Acceleration",names(data2))
names(data2)<-gsub("Gyro","Gyroscope",names(data2))
names(data2)<-gsub("fBody","frequencyBody",names(data2))
names(data2)<-gsub("frequencyBodyBody","frequencyBody",names(data2))
names(data2)<-gsub("Mag","Magnitude",names(data2))
names(data2)


## STEP 5. From the data set in step 4, create a second, independent tidy data set with the
## average of each variable for each activity and each subject.
library(dplyr)
data2<-arrange(data2,subject,activity)
## Break up data set into groups of rows based on variable values. In this case by subject and then activity.
groupedData<-group_by(data2,subject,activity)
## Calculate mean of all other columns
data3<-summarize_all(groupedData,mean)
## Drop mode column
final_data<-select(data3,-mode)
final_data[1:5,1:5]
##Converting from tibble to data frame
final_data<-as.data.frame(final_data)
dim(final_data)


## Please upload the tidy data set created in step 5 of the instructions. Please upload your data
## set as a txt file created with write.table() using row.name=FALSE (do not cut and paste a
## dataset directly into the text box, as this may cause errors saving your submission).

write.table(final_data, file="final_data.txt",row.name=FALSE)





