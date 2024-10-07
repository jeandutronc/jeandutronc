I have the following code that is throwing a "the truth value of a series is ambiguous" error. The isse appears on if matched_address:
I had a previous version that didn't have the expanded address check and this line worked fine. I don't understand why it worked before and not now. If I understand correctly, matched_address is a row of referential_df, and if matched_address whether it's empty or not. Why isn't it working?

# Function to match abbreviations (multiple letters allowed)
def match_abbreviation(token, referential_word):
    abbreviation_match = re.match(r'^([A-Za-zéèêëïîôöùüçÉÈÊËÏÎÔÖÙÜÇ]+)\.$', token)
    if abbreviation_match:
        return referential_word.startswith(abbreviation_match.group(1))
    return False


# Function to insert a space after a period if no space exists
def match_address(client_address, referential_tokens):
    client_address = re.sub(r'(?<=\w)\.(?=\w)', '. ', client_address)
    client_address = client_address.replace('-',' ')
    client_tokens = client_address.split()
    
    if len(client_tokens) != len(referential_tokens):
        return False  # Token lengths don't match
    
    for client_token, referential_token in zip(client_tokens, referential_tokens):
        if '.' in client_token:
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
    referential_df['tokenized_address'] = referential_df['street'].apply(lambda addr: addr.replace('-', ' ').split())

    mask = (client_df['kl_country']=='BE') & (client_df['normalised_street'].isna())
    total_missing = mask.sum()
    count = 0

    # Use a list to collect results for batch updating
    updates = []

    # Iterate over each row in the filtered client dataframe
    for idx in client_df[mask].index:
        count+=1
        print(f'processing row {count} of {total_missing} - {round(count*100.0/total_missing,2)}%',end ='\r')
        
        client_address = client_df.at[idx,'kl_street_modified']
        client_zipcode = client_df.at[idx,'kl_postcode']

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
            elif match_with_expansion(client_address, referential_tokens):
                matched_address = referential_row
                break

        # If a match is found, update the client dataframe
       # return matched_address
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
#
