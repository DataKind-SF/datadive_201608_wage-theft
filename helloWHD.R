library(data.table)
library(plyr)
library(dplyr)
library(lubridate)
library(ggplot2)

####################
# Read the data
####################

whd_dictionary <- read.csv("~/datadive_201608_wage-theft/data/whd_data_dictionary.csv", stringsAsFactors = F)
whd <- as.data.frame(fread("~/datadive_201608_wage-theft/data/whd_whisard.csv"))

# The fread warning tells us that one of the entries in column "naics_code" is not like the others.
weird_col <- colnames(whd)[8]
# Use the data dictionary to figure out what this column is. This column is a code
# that tells you the industry of the violating company.
subset(whd_dictionary, Column_Name == weird_col)
# parse dates
whd <- whd %>% mutate(start_year = year(ymd(findings_start_date)),
                      end_year = year(ymd(findings_end_date)))


########################
# Search for interesting things
########################
# Find cases by name of company
subset(whd, grepl("Trump", legal_name))[, 1:10]
# Find cases with large payments
whd[which.max(whd$bw_atp_amt), 1:20]

########################
# Make pictures
########################
yearWhd <- whd %>% group_by(end_year) %>% summarize(yearly_sum = sum(bw_atp_amt))

ggplot(yearWhd, aes(x = end_year, y = yearly_sum)) + 
  geom_point() + 
  geom_line()

ggplot(whd, aes(x = factor(end_year), y = log10(bw_atp_amt))) + 
  geom_boxplot() 


########################
# Data issues -- figure out how to fix problems like these!
########################
# legal names missing
temp <- subset(whd, grepl("Harrah's Casino", whd$trade_nm))
# multiple wal-marts
temp <- whd[grepl("wal mart", whd$legal_name, ignore.case = T) | grepl("wal mart", whd$trade_nm, ignore.case = T),]
# typos in names
temp <- whd[grepl("eldoraldo", whd$trade_nm, ignore.case = T),]
# some dates are wrong
range(whd$start_year)




