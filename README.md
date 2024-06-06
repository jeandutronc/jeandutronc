data = {'psp':['19408416','19217569','11709945','11709945','25851825','12345'],
        'kl_company_name':['EUROPARKING','EUROPARKING','BUYSSE MARNIX','BUYSSE MARNIX','JS HANDSURGERY','CHarles'],
        'kl_ben':[None,'0461950721','0711418685','0711418685','0784674669',None]
       }
df = pd.DataFrame(data)



duplicate_id_card = df['kl_ben'].duplicated(keep=False)

anomalies = df[duplicate_id_card].groupby('kl_ben')['kl_company_name'].nunique() > 1

is_anomalie = df['kl_ben'].isin(anomalies.index)

is_anomalie & df['kl_ben'].notna()
