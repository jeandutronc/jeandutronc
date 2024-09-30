# Function to match abbreviations (multiple letters allowed)
def match_abbreviation(token, referential_word):
    abbreviation_match = re.match(r'^([A-Za-z]+)\.$', token)
    if abbreviation_match:
        return referential_word.startswith(abbreviation_match.group(1))
    return False

# Function to insert a space after a period if no space exists
def match_address(client_address, referential_tokens):
    # Add space after period in client address if needed

    client_address = re.sub(r'(?<=\w)\.(?=\w)', '. ', client_address)
    
    # Tokenize client address
    client_tokens = client_address.split()
    
    # Compare tokens
    for client_token, referential_token in zip(client_tokens, referential_tokens):
        # Handle abbreviations
        if '.' in client_token:

            if not match_abbreviation(client_token, referential_token):
                return False  # Abbreviation doesn't match
        else:
            if client_token.lower() != referential_token.lower():
                return False  # Full words don't match
            
    return True  # All tokens matched

def find_matches(client_df, referential_df):
    # Tokenize all referential addresses once

    referential_df['tokenized_address'] = referential_df['street'].apply(lambda addr: addr.split())
    count=1
    # Iterate over each row in the client dataframe
    for idx, client_row in client_df.iterrows():
        print(f'processing row {count}',end='\r')
        # Skip rows where normalised_street is already filled

        if pd.notna(client_row['normalised_street']):
            continue

        client_address = client_row['kl_street_modified']
        client_zipcode = client_row['kl_postcode']

        # Filter referential dataframe by zipcode
        referential_subset = referential_df[(referential_df['postcode'] == client_zipcode) & (referential_df['street']!="") ]

        # Check for address matches in the filtered subset
        matched_address = None
        
        for _, referential_row in referential_subset.iterrows():
            referential_tokens = referential_row['tokenized_address']  # Use pre-tokenized referential address
            if match_address(client_address, referential_tokens):
                matched_address = referential_row['street']
                break
        
        # Update the matched address in the dataframe if a match is found
        if matched_address is not None:
            client_df.at[idx, 'normalised_street'] = referential_row['street']
            client_df.at[idx, 'normalised_city'] = referential_row['city']
            client_df.at[idx, 'normalised_postcode'] = referential_row['postcode']
            client_df.at[idx, 'reference_street_id'] = referential_row['street_id']
        count+= count+1
    return client_df

matched_addresses_df = find_matches(matched_addresses_df,df_address)

print(f"{round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df)* 100,2)}% match")
