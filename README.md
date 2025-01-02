# Function to match abbreviations (multiple letters allowed)
def match_abbreviation(token, referential_word):

    # Check for abbreviation in token
    token_abbreviation_match = re.match(r'^([A-Za-zéèêëïîôöùüçÉÈÊËÏÎÔÖÙÜÇ]+)\.$', token)
    if token_abbreviation_match:
        return referential_word.startswith(token_abbreviation_match.group(1))

    # Check for abbreviation in referential_word
    referential_word_abbreviation_match = re.match(r'^([A-Za-zéèêëïîôöùüçÉÈÊËÏÎÔÖÙÜÇ]+)\.$', referential_word)
    if referential_word_abbreviation_match:
        return token.startswith(referential_word_abbreviation_match.group(1))

    # If no abbreviation is found, check for exact match
    return token.lower() == referential_word.lower()

# Function to insert a space after a period if no space exists
def match_address(client_address, referential_tokens):

    client_address = re.sub(r'(?<=\w)\.(?=\w)', '. ', client_address)
    client_address = client_address.replace('-', ' ')
    client_tokens = client_address.split()

    if len(client_tokens) != len(referential_tokens):
        return False  # Token lengths don't match

    for client_token, referential_token in zip(client_tokens, referential_tokens):
        if not match_abbreviation(client_token, referential_token):
            return False  # Tokens don't match

    return True  # All tokens matched


# New function to handle address expansion
def match_with_expansion(client_address, referential_tokens):
    # Expand client address with libpostal
    expansions = expand_address(client_address)

    # Try to match each expanded address
    for expanded_address in expansions:
        if match_address(expanded_address, referential_tokens):
            return True
    
    return False  # None of the expanded versions matched



def find_matches(client_df,client_address_field, referential_df, step):
    # Tokenize referential addresses once
    referential_df['tokenized_address'] = referential_df['street'].apply(lambda addr: addr.replace('-', ' ').split())

    mask = (client_df[countrycode]=='be') & (client_df['normalised_street'].isna()) & (client_df[street].notna())
    total_missing = mask.sum()
    count = 0

    # Use a list to collect results for batch updating
    updates = []

    # Iterate over each row in the filtered client dataframe
    for idx in client_df[mask].index:
        count+=1
        print(f'Step {step} : processing row {count} of {total_missing} - {round(count*100.0/total_missing,2)}%',end ='\r')
        
        client_address = client_df.at[idx, client_address_field]
        client_zipcode = client_df.at[idx,postalcode]


        # Filter referential dataframe by zipcode
        referential_subset = referential_df[(referential_df['postcode'] == client_zipcode) & (referential_df['street'] != "")]

        # Check for address matches in the filtered subset
        matched_address = None
        
        for _, referential_row in referential_subset.iterrows():
            
            referential_tokens = referential_row['tokenized_address']

            # Try matching with the original address first
            if match_address(client_address, referential_tokens):
                matched_address = referential_row
                break


       # return matched_address
        if matched_address is not None:
            updates.append({
                'index': idx,
                'street': matched_address['street'],
                'postcode': matched_address['postcode'],
                'street_id': matched_address['street_id']
            })

    # Update the client_df in one go
    for update in updates:
        client_df.at[update['index'], 'normalised_street'] = update['street']
        client_df.at[update['index'], 'normalised_postcode'] = update['postcode']
        client_df.at[update['index'], 'reference_street_id'] = update['street_id']
    
    return client_df


def parse_full_address(df, address_types, street_cols, city_cols, postcode_cols, country_cols):
    # Iterate over the address types
    for address_type, street_col, city_col, postcode_col, country_col in zip(address_types, street_cols, city_cols, postcode_cols, country_cols):
        # Create full address by concatenating street, city, postcode, and country
        df[f'full_address_{address_type}'] = (
            df[street_col].fillna('') + ', ' +
            df[city_col].fillna('') + ', ' +
            df[postcode_col].fillna('') + ', ' +
            df[country_col].fillna('')
        )
        
        # Apply address parsing function
        parsed_addresses = df[f'full_address_{address_type}'].apply(parse_address)
        
        # Initialize new columns for structured address components
        df[f'parsed_street_{address_type}'] = None
        df[f'parsed_postcode_{address_type}'] = None
        df[f'parsed_city_{address_type}'] = None
        df[f'parsed_country_{address_type}'] = None

        # Process parsed addresses and assign components to respective columns
        for idx, parsed in enumerate(parsed_addresses):
            for value, component in parsed:
                if component == 'house_number':
                    continue  # Ignore house numbers
                elif component == 'road':
                    df.at[idx, f'parsed_street_{address_type}'] = value
                elif component == 'postcode':
                    df.at[idx, f'parsed_postcode_{address_type}'] = value
                elif component == 'city':
                    df.at[idx, f'parsed_city_{address_type}'] = value
                elif component == 'country':
                    df.at[idx, f'parsed_country_{address_type}'] = value

    return df


def run_process(df,address_type):
    street= f'parsed_street_{address_type}'
    street_unparsed = f'{address_type}Street'
    
    city= f'parsed_city_{address_type}'
    city_unparsed = f'{address_type}City'
    
    postalcode= f'parsed_postcode_{address_type}' 
    postalcode_unparsed = f'{address_type}PostalCode'
    
    countrycode = f'parsed_country_{address_type}'
    countrycode_unparsed = f'{address_type}CountryCode'

    work_df = df[['psp',street_unparsed,city_unparsed,postalcode_unparsed,countrycode_unparsed,street,city,postalcode,countrycode]].copy()
    
    street_lower = street+'_lower'
    
    
    # STEP 1
    
    work_df[street_lower] = work_df[street].str.lower()
    
    matched_addresses_df = pd.merge(work_df,sopres,left_on =[postalcode,street_lower],right_on =['postcode','street_lower'], how='left').sort_values(by=['psp','street_lower'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')
    
    
    matched_addresses_df['match_step'] = None
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 1' if pd.notnull(row['postcode']) else row['match_step'], axis=1)
    
    matched_addresses_df = matched_addresses_df.rename(columns={'street':'normalised_street'
                                 ,'postcode':'normalised_postcode'
                                 ,'street_id':'reference_street_id'})
    
    matched_addresses_df['matched'] = ~matched_addresses_df['normalised_street'].isna()
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
     street_lower,
    'street_lower',
    'address',
    'expanded_address'])
    
    print(f"Step 1 : Sopres - regular match - {round(len(matched_addresses_df[(matched_addresses_df[countrycode]!='be') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
  
    # STEP 2
   

    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'axepta_address'] = matched_addresses_df.loc[~matched_addresses_df['matched'], street].fillna('')+' '+matched_addresses_df.loc[~matched_addresses_df['matched'], postalcode].fillna('')
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_axepta_address'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'axepta_address'].fillna(' ').apply(expand_address)
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'axepta_street_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], street].astype(str).apply(modify_street)
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'axepta_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'axepta_street_modified'].fillna('')+' '+matched_addresses_df.loc[~matched_addresses_df['matched'], postalcode].fillna('')
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_axepta_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'axepta_address_modified'].fillna(' ').apply(expand_address)
        
    matched_addresses_df = matched_addresses_df.explode('expanded_axepta_address')
    
    matched_addresses_df = pd.merge(matched_addresses_df,sopres_exploded,left_on ='expanded_axepta_address',right_on ='expanded_address', how='left').sort_values(by=['psp','street'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')
    
    matched_addresses_df['normalised_street']   = matched_addresses_df['normalised_street'].fillna(matched_addresses_df['street']) 
    matched_addresses_df['normalised_postcode'] = matched_addresses_df['normalised_postcode'].fillna(matched_addresses_df['postcode'])
    matched_addresses_df['reference_street_id'] = matched_addresses_df['reference_street_id'].fillna(matched_addresses_df['street_id'])
    
    
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 2' if pd.notnull(row['postcode']) else row['match_step'], axis=1)
    matched_addresses_df['matched'] = ~matched_addresses_df['reference_street_id'].isna()
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
    'street',
    'postcode',
    'street_id',
    'axepta_address',
    'address',
    'expanded_address',
    'street_lower'])
    
    print(f"Step 2 : Sopres - match with NPL - {round(len(matched_addresses_df[(matched_addresses_df[countrycode]!='be') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
    
   
    # STEP 3
    
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'expanded_axepta_address_modified'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'axepta_address_modified'].fillna(' ').apply(expand_address)
    matched_addresses_df = matched_addresses_df.explode('expanded_axepta_address_modified')
    
    matched_addresses_df = pd.merge(matched_addresses_df,sopres_exploded,left_on ='expanded_axepta_address_modified',right_on ='expanded_address', how='left').sort_values(by=['psp','street'],ascending=[True,True],na_position='last').drop_duplicates(subset='psp',keep='first')
    
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_street']   = matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_street'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'street']) 
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_postcode'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'normalised_postcode'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'postcode'])
    matched_addresses_df.loc[~matched_addresses_df['matched'], 'reference_street_id'] = matched_addresses_df.loc[~matched_addresses_df['matched'], 'reference_street_id'].fillna(matched_addresses_df.loc[~matched_addresses_df['matched'], 'street_id'])
    
    
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 3' if pd.notnull(row['postcode']) else row['match_step'], axis=1)
    
    matched_addresses_df['matched'] = ~matched_addresses_df['reference_street_id'].isna()
    
    matched_addresses_df = matched_addresses_df.drop(columns=[
    'street',
    'street_lower',
    'postcode',
    'address',
    'expanded_address',
    'street_id'])
   
    print(f"Step 3 : Sopres - match with NPL on modified streets - {round(len(matched_addresses_df[(matched_addresses_df[countrycode]!='be') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
   
   # Step 4
   
    matched_addresses_df = find_matches(matched_addresses_df, 'axepta_street_name', sopres, 4)
   
    print(f"Step 4 : Sopres - match with abbreviations - {round(len(matched_addresses_df[(matched_addresses_df[countrycode]!='be') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
   
    matched_addresses_df['match_step'] = matched_addresses_df.apply(lambda row: 'function 4' if pd.notnull(row['reference_street_id']) and pd.isnull(row['match_step']) else row['match_step'], axis=1)
   


run_process(accounts_main_dataframe,'Billing')

gives me NameError: name 'countrycode' is not defined
But countrycode is defined in the last function
