library(data.table)
library(plyr)
library(dplyr)
library(stringr)

whd <- as.data.frame(fread("~/datadive_201608_wage-theft/data/whd_whisard.csv"))

colnames(whd)
str(whd$naic_cd)

getShortCode <- function(currCode, depth){
  if(nchar(currCode) < depth) return("")
  return(substr(currCode, 1, depth))
}

whd$naic_cd_lvl1 <- vapply(whd$naic_cd, function(x) getShortCode(x, 1), character(1))
whd$naic_cd_lvl2 <- vapply(whd$naic_cd, function(x) getShortCode(x, 2), character(1))
whd$naic_cd_lvl3 <- vapply(whd$naic_cd, function(x) getShortCode(x, 3), character(1))
whd$naic_cd_lvl4 <- vapply(whd$naic_cd, function(x) getShortCode(x, 4), character(1))
whd$naic_cd_lvl5 <- vapply(whd$naic_cd, function(x) getShortCode(x, 5), character(1))
whd$naic_cd_lvl6 <- vapply(whd$naic_cd, function(x) getShortCode(x, 6), character(1))

naicsCodes <- read.table("~/datadive_201608_wage-theft/data/sandbox/NAICS/2012_NAICS_Structure.csv",
                         skip = 7, sep = ",", stringsAsFactors = FALSE, header = TRUE, as.is = TRUE)
naicsCodes <- naicsCodes[,2:3]
colnames(naicsCodes) <- c("code", "name")
# trim leading and trailing whitespace
naicsCodes <- naicsCodes %>% mutate(name = str_trim(name))

write.csv(whd, "~/datadive_201608_wage-theft/data/processedWhdData/whd_whisard.naicNumericLevels.csv",
          row.names = FALSE)

temp <- read.csv("~/datadive_201608_wage-theft/data/processedWhdData/whd_whisard.naicNumericLevels.csv")

head(naicsCodes)
temp <- whd %>% select(naic_cd,
                       naic_cd_lvl1, naic_cd_lvl2, naic_cd_lvl3,
                       naic_cd_lvl4, naic_cd_lvl5, naic_cd_lvl6)

colnames(whd)


