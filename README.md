Here is the amended code addressing your third step: ensuring that libpostal’s expand_address is used when abbreviations might not match.

I’ve added a function to expand the client address using libpostal, and the match_address function now compares against all possible expansions of the client address. This should ensure that abbreviations are expanded properly and matched correctly.

Here are the changes I’ve made to your script:

import re
from postal.expand import expand_address  # Make sure to have libpostal installed

# Function to match abbreviations (multiple letters allowed)
def match_abbreviation(token, referential_word):
    abbreviation_match = re.match(r'^([A-Za-zéèêëïîôöùüçÉÈÊËÏÎÔÖÙÜÇ]+)[.-]*$', token)  # Handle '.' or '-'
    if abbreviation_match:
        return referential_word.startswith(abbreviation_match.group(1))
    return False

# Function to insert a space after a period if no space exists
def match_address(client_address, referential_tokens):
    client_address = re.sub(r'(?<=\w)\.(?=\w)', '. ', client_address)
    client_tokens = client_address.split()

    for client_token, referential_token in zip(client_tokens, referential_tokens):
        if '.' in client_token or '-' in client_token:  # Also check for '-'
            if not match_abbreviation(client_token, referential_token):
                return False  # Abbreviation doesn't match
        else:
            if client_token.lower() != referential_token.lower():
                return False  # Full words don't match
            
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

def find_matches(client_df, referential_df):
    # Tokenize referential addresses once
    referential_df['tokenized_address'] = referential_df['street'].apply(lambda addr: addr.split())

    mask = (client_df['kl_country']=='BE') & (client_df['normalised_street'].isna())
    total_missing = mask.sum()
    count = 0

    # Use a list to collect results for batch updating
    updates = []

    # Iterate over each row in the filtered client dataframe
    for idx in client_df[mask].index:
        count += 1
        print(f'processing row {count} of {total_missing} - {round(count*100.0/total_missing,2)}%', end='\r')
        
        client_address = client_df.at[idx, 'kl_street_modified']
        client_zipcode = client_df.at[idx, 'kl_postcode']

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

            # If no match, try expanded address matching
            if match_with_expansion(client_address, referential_tokens):
                matched_address = referential_row
                break

        # If a match is found, update the client dataframe
        if matched_address:
            updates.append({
                'index': idx,
                'street': matched_address['street'],
                'city': matched_address['city'],
                'postcode': matched_address['postcode'],
                'street_id': matched_address['street_id']
            })

    # Update the client_df in one go
    for update in updates:
        client_df.at[update['index'], 'normalised_street'] = update['street']
        client_df.at[update['index'], 'normalised_city'] = update['city']
        client_df.at[update['index'], 'normalised_postcode'] = update['postcode']
        client_df.at[update['index'], 'reference_street_id'] = update['street_id']
    
    return client_df

# Example call to the function
matched_addresses_df = find_matches(matched_addresses_df, df_address)

print()
print(f"{round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")

Changes Summary:

	1.	Abbreviation Handling (match_abbreviation): The regular expression has been updated to handle both dots (.) and hyphens (-) in abbreviations.
	2.	Address Expansion (match_with_expansion): This new function uses libpostal’s expand_address to generate multiple possible expansions of the client address. It tries matching each expanded version against the referential tokens.
	3.	Matching Process: In the find_matches function, if the regular match_address fails, the function will try using match_with_expansion to see if any expanded version of the client address matches the referential.

This solution should help you properly match the remaining cases where libpostal could expand abbreviations and should improve the accuracy of the address matching.
