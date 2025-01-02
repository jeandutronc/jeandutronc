# STEP 2
    
    matched_addresses_df['matched'] = ~matched_addresses_df['normalised_street'].isna()
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_address'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_street_name'].fillna('')+' '+matched_addresses_df.loc[~matched_addresses_df['matched'], 'kl_postcode'].fillna('')
