import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


datadir = 'data'

judgements_files = 'SJOjudgements2-3.csv'
data_dic_file = 'whd_data_dictionary.csv'
whisard = 'whd_whisard.csv'

judgements = pd.read_csv(datadir + '/' + judgements_files)
data_dic = pd.read_csv(datadir + '/' + data_dic_file)
whi = pd.read_csv(datadir + '/' + whisard)

cols_use = ['case_id',
            'trade_nm',
            'legal_name',
            'street_addr_1_txt',
            'cty_nm',
            'st_cd',
            'zip_cd',
            'naic_cd',
            'naics_code_description',
            'case_violtn_cnt',
            'cmp_assd_cnt',
            'ee_violtd_cnt',
            'bw_atp_amt',
            'flsa_bw_atp_amt',
            'flsa_ee_atp_cnt',
            'flsa_mw_bw_atp_amt',
            'flsa_ot_bw_atp_amt',
            'flsa_15a3_bw_atp_amt',
            'flsa_cmp_assd_amt',
            'findings_start_date',
            'findings_end_date']



whi['findings_start_date_datetime'] = whi['findings_start_date'].replace({'-0': '-'}, regex=True)
whi['findings_start_date_datetime'] = pd.to_datetime(whi[whi['findings_start_date_datetime']>'2007']['findings_start_date_datetime'])


whi['findings_start_date'] = pd.to_datetime(whi[whi['findings_start_date']>'1900']['findings_start_date'])
whi['findings_end_date'] = pd.to_datetime(whi[whi['findings_end_date']>'1900']['findings_end_date'])

whi['findings_start_date_m'] = whi['findings_start_date'].apply(lambda x: x.month)
whi['findings_end_date_m'] = whi['findings_end_date'].apply(lambda x: x.month)



whi['findings_start_date_y'] = whi['findings_start_date'].apply(lambda x: x.year)
whi['findings_end_date_y'] = whi['findings_end_date'].apply(lambda x: x.year)


whi.groupby(['findings_start_date_y', 'st_cd']).size().plot()
plt.show()


states = whi['st_cd'].unique()[:-1]

cts_by_st_y = []
for st in states:
    whi[whi['st_cd'] == st].groupby('findings_start_date_y').size()
    df_tmp = pd.DataFrame(whi[whi['st_cd'] == st].groupby('findings_start_date_y').size())
    df_tmp.columns = [st]
    cts_by_st_y.append(df_tmp)


cts_by_st_y = pd.concat(cts_by_st_y, axis = 1)

states_vis = cts_by_st_y.max(axis=0).sort_values(ascending=False).iloc[:10].index

ax = cts_by_st_y[states_vis].plot()
ax.set_xlim([2000, 2016])
plt.show()

popd =pd.read_csv('~/Desktop/ST-EST00INT-ALLDATA.csv')

popd[(popd['SEX']==0) & (popd['ORIGIN']==0) & (popd['AGEGRP']==0) & (popd['RACE']==0)]
