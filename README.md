import pandas as pd
import re

# Function to match abbreviations (multiple letters allowed)
def match_abbreviation(token, referential_word):
    abbreviation_match = re.match(r'^([A-Za-z]+)\.$', token)
    if abbreviation_match:
        return referential_word.startswith(abbreviation_match.group(1))
    return False

# Function to insert a space after a period if no space exists
def match_address(client_address, referential_tokens):
    client_address = re.sub(r'(?<=\w)\.(?=\w)', '. ', client_address)
    client_tokens = client_address.split()
    
    for client_token, referential_token in zip(client_tokens, referential_tokens):
        if '.' in client_token:
            if not match_abbreviation(client_token, referential_token):
                return False  # Abbreviation doesn't match
        else:
            if client_token.lower() != referential_token.lower():
                return False  # Full words don't match
            
    return True  # All tokens matched

def find_matches(client_df, referential_df):
    # Tokenize referential addresses once
    referential_df['tokenized_address'] = referential_df['street'].apply(lambda addr: addr.split())

    # Filter out rows that already have normalised_street filled
    client_df = client_df[client_df['normalised_street'].isna()]

    # Use a list to collect results for batch updating
    updates = []

    # Iterate over each row in the filtered client dataframe
    for idx, client_row in client_df.iterrows():
        client_address = client_row['kl_street_modified']
        client_zipcode = client_row['kl_postcode']

        # Filter referential dataframe by zipcode
        referential_subset = referential_df[(referential_df['postcode'] == client_zipcode) & (referential_df['street'] != "")]

        # Check for address matches in the filtered subset
        matched_address = None
        
        for _, referential_row in referential_subset.iterrows():
            referential_tokens = referential_row['tokenized_address']
            if match_address(client_address, referential_tokens):
                matched_address = referential_row['street']
                # Collect the update information
                updates.append({
                    'index': idx,
                    'street': referential_row['street'],
                    'city': referential_row['city'],
                    'postcode': referential_row['postcode'],
                    'street_id': referential_row['street_id']
                })
                break

    # Update the client_df in one go
    for update in updates:
        client_df.at[update['index'], 'normalised_street'] = update['street']
        client_df.at[update['index'], 'normalised_city'] = update['city']
        client_df.at[update['index'], 'normalised_postcode'] = update['postcode']
        client_df.at[update['index'], 'reference_street_id'] = update['street_id']
    
    return client_df

# Example call to the function
matched_addresses_df = find_matches(matched_addresses_df, df_address)

print(f"{round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
