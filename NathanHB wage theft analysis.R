# Wage theft data analysis

# levels 3 and 4, third and fourth digit of naic_cd

# total outcome var (backwages): bw_atp_amt
# number of employees: ee_atp_cnt
# per emplyoyee can be calc by bw_atp_amt/ee_atp_cnt

# end of violation is usually beginning of investigation: findings_end
# 2008 - 2014 will be the full years


# law code (e.g. min wage, overtime)- flsa_violtn
# worth investigating specifically - min wage (more serious problems): flsa_mw_bw_atp_amt
# number of emplyees paid out to for min wage viol: flsa_ee_atp_cnt

# naic_cd2 ,3 ,4


# join zipcodes to counties to FIPS (FIPS is ultimate goal, b/c geolocation best w FIPS)

# egregiousness - total size or total per emp
# vulnerability - min wage focused, low wage counties

# Questions: Industries (at each naic level 2,3,4,5) ranked by:
# 1. total back wages (egregiousness focus)
# 2. back wages per worker
# 3. total minimum-wage-violation back wages (vulnerability focus)
# 4. min-wage-bw per worker

# Note: check for outliers, present the data both with and without

# 5. Check for correlations with demographic data, by industry and county
# 6. Find unusual data points (high or low) to help find possible trouble spots
# Particulary places that seem oddly low
# Consider that most egregious cases may not have been identified yet


# 7. Save results in a format which can be managed and added to consistently going forward into the future (perhaps an online SQL database)

# Step 1: load data and packages
library("readr")
library("dplyr")
violations_path = "/Users/nathanhelm-burger/Documents/Dropbox/datadive_wagetheft/data/processedWhdData/"
#df = data.frame(read_csv(paste0(violations_path, "whd_whisard.naicNumericLevels.csv")))
df = read.csv(paste0(violations_path, "whd_whisard.naicNumericLevels.csv"))
#colnames(df)
df_subset = df[c(1:10, 12:14, 111:116)]
df_subset = cbind(df_subset, df$flsa_bw_atp_amt, df$flsa_ee_atp_cnt)
dim(df_subset)
#df_subset = na.omit(df_subset)
#summary(df_subset)
#colnames(df_subset)
naic_level_names = lapply(colnames(df_subset[14:19]), as.symbol)
colnames(df_subset)[20] = "flsa_mw_bw_atp_amt"
colnames(df_subset)[21] = "flsa_ee_atp_cnt"
# Loop to create and write to csv each naic level grouping

for(naic_lvl in 2:5){
  # Total Backwage Info: bw_atp_amt, ee_atp_cnt
  # Minimum wage info: flsa_mw_bw_atp_amt, flsa_ee_atp_cnt
  df_grouped = df_subset %>% group_by_(.dots=naic_level_names[naic_lvl])
  sum_df_byNaic = summarize(df_grouped,
                            industries = n(),
                            total_industry_bw = sum(bw_atp_amt, na.rm = TRUE),
                            avg_industry_bw = sum(bw_atp_amt, na.rm = TRUE)/n(),
                            bw_per_emp = sum(bw_atp_amt, na.rm = TRUE)/sum(ee_atp_cnt, na.rm = TRUE),
                            total_industry_bw_mw = sum(flsa_mw_bw_atp_amt, na.rm = TRUE),
                            avg_industry_bw_mw = sum(flsa_mw_bw_atp_amt, na.rm = TRUE)/n(),
                            bw_mw_per_emp = sum(flsa_mw_bw_atp_amt, na.rm = TRUE)/sum(flsa_ee_atp_cnt, na.rm = TRUE))

  filename = paste0("df_grouped_byNaic", as.character(naic_lvl))
  filename = paste0(filename, ".csv")
  print(filename)
  write.csv(sum_df_byNaic, filename, row.names = FALSE)
}

# open csv, join the names, write updated csv
naic_name_df = read.csv("2012_NAICS_Structure_FINAL.csv")

for(naic_lvl in 2:5){
  filename = filename = paste0("df_grouped_byNaic", as.character(naic_lvl))
  filename = paste0(filename, ".csv")
  temp_df = read.csv(filename)
  colnames(temp_df)[1] = "NAICS.Code"
  # print(colnames(temp_df))
  temp_df = left_join(temp_df, naic_name_df,
            by=c("NAICS.Code" = "NAICS.Code"))

  write.csv(temp_df, filename, row.names = FALSE)
}

dfby2 = read.csv("df_grouped_byNaic2.csv")
dfby3 = read.csv("df_grouped_byNaic2.csv")


# Demographic data and industry data

# Load and join industry data
industry_df1 = read.csv("/Users/nathanhelm-burger/Documents/Dropbox/datadive_wagetheft/data/census/County Business Patterns/CountyBusinessPatternsCaliforniaNAICS2.csv")
industry_df2 = read.csv("/Users/nathanhelm-burger/Documents/Dropbox/datadive_wagetheft/data/census/County Business Patterns/CountyBusinessPatternsCaliforniaNAICS3.csv")
colnames(industry_df1)
colnames(industry_df2)
head(industry_df1)
head(industry_df2)
for(name_col in 5:9){
 colnames(industry_df2)[name_col] = paste0("Industry_NAICS3_", colnames(industry_df2)[name_col])
}
for(name_col in 5:9){
  colnames(industry_df1)[name_col] = paste0("Industry_NAICS2_", colnames(industry_df1)[name_col])
}


industry_df_full = full_join(industry_df1, industry_df2)

View(industry_df_full)

demg_path = "/Users/nathanhelm-burger/Documents/Dropbox/datadive_wagetheft/data/census/"

demg1 = read_csv(paste0(demg_path, "county_wide_demographic.csv"))
colnames(demg1)[1] = "County"

colnames(demg1)
dim(demg1)
industry_df_full$STATE = 6
demg1$County = as.factor(demg1$County)
california_demg = demg1[demg1['STATE']==6,]
dim(california_demg)
dim(industry_df_full)
california_demg$County = as.factor(california_demg$County)
setdiff(california_demg$County, industry_df_full$County)
industry_demg = full_join(industry_df_full, california_demg)
dim(industry_demg)
dim(industry_df_full)
dim(california_demg)

colnames(industry_demg)[4] = "naic_cd_lvl2"
colnames(industry_demg)[10] = "naic_cd_lvl3"

colnames(df)
colnames(industry_demg)[2] = "st_cd"
write.csv(industry_demg, "industry_and_demographics.csv")
str(industry_demg$naic_cd_lvl3)
industry_demg$naic_cd_lvl3 = as.factor(industry_demg$naic_cd_lvl3)
joined_df = left_join(df, industry_demg)
dim(joined_df)
dim(df)
write.csv(joined_df, "demographic_industry_violations.csv")






