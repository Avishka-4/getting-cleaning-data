#here download the Zip file to desktop and unzip it(use an unzipping app)
setwd("~/Desktop/UCI HAR Dataset")

library(dplyr)

cat("Script started.\n")

cat("Loading activity labels...\n")
activity_labels <- read.table("activity_labels.txt", quote = "\"", comment.char = "")

cat("Activity labels loaded.\n")

cat("Loading dataset...\n")
features <- read.table("features.txt", quote = "\"", comment.char = "")
train_data <- read.table("train/X_train.txt")
test_data <- read.table("test/X_test.txt")
merged_data <- rbind(train_data, test_data)

cat("Dataset loaded.\n")

cat("Extracting mean and standard deviation measurements...\n")
mean_std_cols <- grep("-(mean|std)\\(\\)", features$V2)
merged_data <- merged_data[, mean_std_cols]

cat("Extraction complete.\n")

cat("Loading activity labels...\n")
train_labels <- read.table("train/y_train.txt")
test_labels <- read.table("test/y_test.txt")
merged_labels <- rbind(train_labels, test_labels)
merged_data$activity <- factor(merged_labels$V1, levels = activity_labels$V1, labels = activity_labels$V2)

cat("Loading subjects...\n")
train_subjects <- read.table("train/subject_train.txt")
test_subjects <- read.table("test/subject_test.txt")
merged_subjects <- rbind(train_subjects, test_subjects)
merged_data$subject <- factor(merged_subjects$V1)

cat("Renaming variables...\n")
names(merged_data) <- gsub("\\(|\\)", "", features$V2[mean_std_cols])
names(merged_data) <- tolower(names(merged_data))
names(merged_data) <- gsub("^t", "time_", names(merged_data))
names(merged_data) <- gsub("^f", "frequency_", names(merged_data))

cat("Creating tidy dataset...\n")
tidy_data <- merged_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

cat("Tidy dataset created.\n")

cat("Writing tidy dataset to file...\n")
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)

cat("Script completed.\n")
