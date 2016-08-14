"""
Census data
https://www.census.gov/popest/data/historical/2000s/vintage_2009/datasets.html

Census data explanation
https://www.census.gov/popest/data/counties/asrh/2009/files/CC-EST2009-ALLDATA.pdf

Race classification
http://www.census.gov/topics/population/race/about.html

"""

import pandas as pd

cols_use = [u'TOT_POP',
            u'TOT_MALE', u'TOT_FEMALE', u'WA_MALE', u'WA_FEMALE', u'BA_MALE',
            u'BA_FEMALE', u'IA_MALE', u'IA_FEMALE', u'AA_MALE', u'AA_FEMALE',
            u'NA_MALE', u'NA_FEMALE', u'TOM_MALE', u'TOM_FEMALE',
            u'H_MALE', u'H_FEMALE']

# state table to map state name to abbreviation
df_st_table = pd.read_csv('data/census/original/state_table.csv')
# fips table to map state abbreviation to fips code
df_fips = pd.read_csv('data/census/original/national_county.txt', header=None)
df_fips.columns = ['STABNAME', 'STCODE', 'FIPSCODE', 'CTYNAME', 'FIPSCLASS']
cols_use2 = ['STCODE', 'FIPSCODE', 'CTYNAME', 'FIPSCLASS']

#################################################################################
# 2010s
demo_2010 = pd.read_csv('data/census/original/CC-EST2015-ALLDATA.csv')
demo_2010 = demo_2010.fillna(0)

# county-wide demography
for i in range(3, 9):
    cw_demo = demo_2010[(demo_2010['AGEGRP']==0) & (demo_2010['YEAR']==i)]
    stname = demo_2010[(demo_2010['AGEGRP']==0) & (demo_2010['YEAR']==i)]\
             [['CTYNAME', 'STNAME']]
    cw_demo = pd.concat([stname, cw_demo[cols_use]], axis=1)

    # add state abbreviation
    cww = pd.merge(cw_demo, df_st_table, how='left', left_on='STNAME', right_on='name')
    # fix disttict of columbia
    cww.loc[cww['name'].isnull(), 'abbreviation'] = 'DC'
    cww.loc[cww['name'].isnull(), 'CTYNAME'] = 'District of Columbia'
    # fix dona ana county
    cww.loc[(cww['CTYNAME'] == 'Do\xf1a Ana County'), 'CTYNAME'] = 'Dona Ana County'

    cww = pd.merge(cww, df_fips, left_on=['abbreviation', 'CTYNAME'],
                   right_on=['STABNAME', 'CTYNAME'])
    cww = cww[cols_use + cols_use2]

    # save
    cww.to_csv('data/census/county_wide_demographic-20%02d.csv' % (i+7))

#################################################################################
# 2000s
nums = [1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18,
        19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
        36, 37, 38, 39, 40, 41, 42, 44, 45, 46, 47, 48, 49, 50, 51,
        53, 54, 55, 56]
st_data = []
for i in nums:
    st_data.append(
        pd.read_csv('data/census/original/cc-est2009-alldata-%02d.csv' % i))
demo_2000 = pd.concat(st_data)
demo_2000 = demo_2000.fillna(0)

# county-wide demography
for i in range(3, 13):
    cw_demo = demo_2000[(demo_2000['AGEGRP']==0) & (demo_2000['YEAR']==i)]
    stname = demo_2000[(demo_2000['AGEGRP']==0) & (demo_2000['YEAR']==i)]\
             [['CTYNAME', 'STNAME']]
    cw_demo = pd.concat([stname, cw_demo[cols_use]], axis=1)

    # add state abbreviation
    cww = pd.merge(cw_demo, df_st_table, how='left', left_on='STNAME', right_on='name')
    # fix disttict of columbia
    cww.loc[cww['name'].isnull(), 'abbreviation'] = 'DC'
    cww.loc[cww['name'].isnull(), 'CTYNAME'] = 'District of Columbia'
    # fix dona ana county
    cww.loc[(cww['CTYNAME'] == 'Do\xf1a Ana County'), 'CTYNAME'] = 'Dona Ana County'

    cww = pd.merge(cww, df_fips, left_on=['abbreviation', 'CTYNAME'],
                   right_on=['STABNAME', 'CTYNAME'])
    cww = cww[cols_use + cols_use2]

    # save
    cww.to_csv('data/census/county_wide_demographic-%04d.csv' % (i+1997))
    

