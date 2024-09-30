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

# Iterate through the client dataframe and find matches
def find_matches(client_df, referential_df):
    # Tokenize all referential addresses once
    referential_df['tokenized_address'] = referential_df['address'].apply(lambda addr: addr.split())
    
    # Iterate over each row in the client dataframe
    for idx, client_row in client_df.iterrows():
        # Skip rows where normalised_street is already filled
        if pd.notna(client_row['normalised_street']):
            continue
        
        client_address = client_row['address']
        client_zipcode = client_row['zipcode']

        # Filter referential dataframe by zipcode
        referential_subset = referential_df[referential_df['zipcode'] == client_zipcode]
        
        # Check for address matches in the filtered subset
        matched_address = None
        for _, referential_row in referential_subset.iterrows():
            referential_tokens = referential_row['tokenized_address']  # Use pre-tokenized referential address
            if match_address(client_address, referential_tokens):
                matched_address = referential_row['address']
                break
        
        # Update the matched address in the dataframe if a match is found
        client_df.at[idx, 'normalised_street'] = matched_address

    return client_df

# Example DataFrames (assuming your actual data is loaded similarly)
client_data = {
    'address': ['Pr.Elizabethln', 'rue A. Dequenne', 'Boulevard Albert II'],
    'zipcode': ['1000', '1000', '1000'],
    'normalised_street': [None, None, 'Boulevard Albert II']  # Only first two rows need matching
}
client_df = pd.DataFrame(client_data)

referential_data = {
    'address': ['Princes Elizabethlaan', 'Rue Alphonse Dequenne', 'Boulevard Albert II'],
    'zipcode': ['1000', '1000', '1000']
}
referential_df = pd.DataFrame(referential_data)

# Run the matching
updated_client_df = find_matches(client_df, referential_df)
print(updated_client_df)
