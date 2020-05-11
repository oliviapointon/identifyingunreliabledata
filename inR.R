# TABLE 1
# Inspect data
head(datasets[["Table 1"]])

# Alias dataframe to make referencing easier
df <- datasets[["Table 1"]]
# How many rows are in the full table?
nrow(df)
# How many unique event_ids are there?
length(unique(df$event_id))

# Convert the data into wide form using the tidyr package
library(tidyr)
data_wide <- spread(df, parameter_name, parameter_value)
head(data_wide)

# What different types of events are in the table?
table(data_wide$event_name)

# Print frequency tables of each parameter_name, including NA values
print("test_assignment Frequency Table")
tafactor<-factor(data_wide$test_assignment, exclude=NULL) 
table(tafactor)
print("test_id Frequency Table")
tidfactor<-factor(data_wide$test_id, exclude=NULL) 
table(tidfactor)

# Check other columns for missing values
apply(data_wide, 2, function(x) sum(length(which(is.na(x)))))

# Check number of events per month, to ensure no periods of missing data. Note that event_time is a character column
class(data_wide$event_time)
table(substr(data_wide$event_time,1,7))

# TABLE 2
# Inspect data
head(datasets[["Table 2"]])

# Convert from a narrow to a wide dataframe using tidyr
df2 <- datasets[["Table 2"]]
data_wide2 <- spread(df2, parameter_name, parameter_value)
head(data_wide2)

# Check event types and check for missing values
print("Event Types")
table(data_wide2$event_name)
print("Missing Values per Column")
apply(data_wide2, 2, function(x) sum(length(which(is.na(x)))))

# Check for periods of missing data
table(substr(data_wide2$event_time,1,7))

# Check for periods of missing data - broken down by platform
table(data_wide2$platform, substr(data_wide2$event_time,1,7))
