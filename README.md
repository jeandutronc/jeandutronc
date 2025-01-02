### pq_writer = None


for i in range(0,1):
    print(f"Started loop {i+1} of {loops}")
    table = pf.read_row_group(i, columns=columns)
    df = table.to_pandas()
    
    
    # STEP 1

    df['kl_street_name_lower'] = df['kl_street_name'].str.lower()
    sopres['street_lower'] = sopres['street'].str.lower()

    matched_addresses_df = pd.merge(df,sopres,left_on =['kl_postcode','kl_street_name_lower'],right_on =['postcode','street_lower'], how='left').sort_values(by=['psp','street_lower'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')

    matched_addresses_df['match_step'] = None
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 1' if pd.notnull(row['postcode']) else row['match_step'], axis=1)
    
    matched_addresses_df = matched_addresses_df.rename(columns={'street':'normalised_street'
                                 ,'postcode':'normalised_postcode'
                                 ,'street_id':'reference_street_id'})
    
    print(f"Step 1 : Sopres - regular match - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
    'kl_street_name_lower',
    'street_lower',
    'address',
    'expanded_address'])
    
    
    
    # STEP 2
    
    matched_addresses_df['matched'] = ~matched_addresses_df['normalised_street'].isna()
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_name'].fillna('')+' '+matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_postcode'].fillna('')
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_kl_address'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address'].fillna(' ').apply(expand_address)
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_name'].astype(str).apply(modify_street)
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_modified'].fillna('')+' '+matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_postcode'].fillna('')
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_kl_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address_modified'].fillna(' ').apply(expand_address)
        
    matched_addresses_df = matched_addresses_df.explode('expanded_kl_address')
    
    matched_addresses_df = pd.merge(matched_addresses_df,sopres_exploded,left_on ='expanded_kl_address',right_on ='expanded_address', how='left').sort_values(by=['psp','street'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')
    
    matched_addresses_df['normalised_street']   = matched_addresses_df['normalised_street'].fillna(matched_addresses_df['street']) 
    matched_addresses_df['normalised_postcode'] = matched_addresses_df['normalised_postcode'].fillna(matched_addresses_df['postcode'])
    matched_addresses_df['reference_street_id'] = matched_addresses_df['reference_street_id'].fillna(matched_addresses_df['street_id'])
    
    
    print(f"Step 2 : Sopres - match with NPL - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
    'street',
    'postcode',
    'street_id',
    'address',
    'expanded_address'])

    
    
    # STEP 3
    
    matched_addresses_df['matched'] = ~matched_addresses_df['reference_street_id'].isna()
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_kl_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address_modified'].fillna(' ').apply(expand_address)
    matched_addresses_df = matched_addresses_df.explode('expanded_kl_address_modified')
    
    matched_addresses_df = pd.merge(matched_addresses_df,sopres_exploded,left_on ='expanded_kl_address_modified',right_on ='expanded_address', how='left').sort_values(by=['psp','street'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_street']   = matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_street'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'street']) 
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_postcode'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_postcode'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'postcode'])
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'reference_street_id'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'reference_street_id'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'street_id'])
    
    print(f"Step 3 : Sopres - match with NPL on modified streets - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
    'street',
    'postcode',
    'address',
    'expanded_address',
    'street_id'])
    
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 3' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)

    
    
    # Step 4
    
    matched_addresses_df = find_matches(matched_addresses_df, 'kl_street_name', sopres, 4)

    print(f"Step 4 : Sopres - match with abbreviations - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 4' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)

    
    
    # Step 5
    
    matched_addresses_df = find_matches(matched_addresses_df, 'kl_street_modified', sopres, 5)
    print(f"Step 5 : Sopres - match with abbreviations on modified streets - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 5' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)
    
    # Add flag if address change is recommended
    matched_addresses_df['modification_suggested'] = (matched_addresses_df['kl_street_name'].str.replace('é','e').str.replace('è','e').str.replace('ê','e').str.replace('î','i').str.replace('ï','i').str.replace('ç','c').str.replace('ô','o').str.replace('û','u').str.upper() != matched_addresses_df['normalised_street'].str.replace('é','e').str.replace('è','e').str.replace('ê','e').str.replace('î','i').str.replace('ï','i').str.replace('ç','c').str.replace('ô','o').str.replace('û','u').str.upper())  &( ~matched_addresses_df['normalised_street'].isna())

    
    
    
    
    
    # STEP 6
    
    matched_addresses_df['matched'] = ~matched_addresses_df['normalised_street'].isna()
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_name'].fillna('')+' '+matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_postcode'].fillna('')
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_kl_address'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address'].fillna(' ').apply(expand_address)
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_name'].astype(str).apply(modify_street)
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_modified'].fillna('')+' '+matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_postcode'].fillna('')
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_kl_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address_modified'].fillna(' ').apply(expand_address)
        
    matched_addresses_df = matched_addresses_df.explode('expanded_kl_address')
    
    matched_addresses_df = pd.merge(matched_addresses_df,df_address_ref_exploded,left_on ='expanded_kl_address',right_on ='expanded_address', how='left').sort_values(by=['psp','street'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')
    
    matched_addresses_df['normalised_street']   = matched_addresses_df['normalised_street'].fillna(matched_addresses_df['street']) 
    matched_addresses_df['normalised_postcode'] = matched_addresses_df['normalised_postcode'].fillna(matched_addresses_df['postcode'])
    matched_addresses_df['reference_street_id'] = matched_addresses_df['reference_street_id'].fillna(matched_addresses_df['street_id'])
    
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 6' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)
        
    
    
    print(f"Step 6 : OA - match with NPL - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
    'street',
    'postcode',
    'street_id',
    'address',
    'expanded_address'])

    
    
    # STEP 7
    
    matched_addresses_df['matched'] = ~matched_addresses_df['reference_street_id'].isna()
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_kl_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address_modified'].fillna(' ').apply(expand_address)
    matched_addresses_df = matched_addresses_df.explode('expanded_kl_address_modified')
    
    matched_addresses_df = pd.merge(matched_addresses_df, df_address_ref_exploded, left_on ='expanded_kl_address_modified', right_on ='expanded_address', how='left').sort_values(by=['psp','street'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_street']   = matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_street'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'street']) 
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_postcode'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_postcode'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'postcode'])
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'reference_street_id'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'reference_street_id'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'street_id'])
    
    print(f"Step 7 : OA - match with NPL on modified streets - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
    'street',
    'postcode',
    'address',
    'expanded_address',
    'street_id'])
    
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 7' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)
   


   # Step 8
   
    matched_addresses_df = find_matches(matched_addresses_df, 'kl_street_name', df_address_ref, 8)
    print(f"Step 8 : OA - match with abbreviations - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
   
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 8' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)
 

   
    # Step 9
    
    matched_addresses_df = find_matches(matched_addresses_df, 'kl_street_modified', df_address_ref, 9)
    print(f"Step 9 : OA - match with abbreviations on modified streets - {round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 9' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)
    
    # Add flag if address change is recommended
    matched_addresses_df['modification_suggested'] = (matched_addresses_df['kl_street_name'].str.replace('é','e').str.replace('è','e').str.replace('ê','e').str.replace('î','i').str.replace('ï','i').str.replace('ç','c').str.replace('ô','o').str.replace('û','u').str.upper() != matched_addresses_df['normalised_street'].str.replace('é','e').str.replace('è','e').str.replace('ê','e').str.replace('î','i').str.replace('ï','i').str.replace('ç','c').str.replace('ô','o').str.replace('û','u').str.upper())  &( ~matched_addresses_df['normalised_street'].isna())
#
 #   
 #   
 #   
 #   
 #   print(f"total match including foreigners {round(len(matched_addresses_df[(~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")

#    
#    # create writer to save file
#    table_to_save  = pa.Table.from_pandas(matched_addresses_df)
#   # if pq_writer == None:
#   #     pq_writer= pq.ParquetWriter('/domino/datasets/local/address-check/kl_matched_addresses.parquet', table_to_save.schema,use_dictionary=True,compression='snappy')
#   ##     
#   # # Write the table to the Parquet file in append mode
#   # pq_writer.write_table(table_to_save)
#   # print('\n')
##pq_writer.close()
#
