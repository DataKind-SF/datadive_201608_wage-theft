# Wage theft data analysis

# levels 3 and 4, third and fourth digit of naic_cd

# total outcome var (backwages): bw_atp_amt
# number of employees: ee_atp_cnt
# per emplyoyee can be calc by bw_tot/emp_cnt

# end of violation is usually beginning of investigation: findings_end
# 2008 - 2014 will be the full years


# law code (e.g. min wage, overtime)- flsa_violtn
# worth investigating specifically - min wage (more serious problems): flsa_mw_bw


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

# 5. Check for correlations with demographic data
# 6. Find unusual data points (high or low) to help find possible trouble spots
# 7. Save results in a format which can be managed and added to consistently going forward into the future (perhaps an online SQL database)

