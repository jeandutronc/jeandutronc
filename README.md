I am trying to match addresses from two different dataframes, one containing my clients' addresses which are often written by hand, the second containing addresses from a referential. I use libpostal to parse the addresses and match them to the referential. I've then modified the street so that the most common abbreviations that are not understood by lipostal are changed to the real word (for example R.d. becomes Rue De ). I have already managed to match 85% of my addresses this way.
The third step is to take abbreviations into account, by finding whether there is a "." in the address and try to match to a word based on what is behind the dot. For example, Pr. Elisabethlaan with match with Princes Elisabeth laan because I find the 2 letters of pr before the dot in the first two letters of Princes.
I will provide you below the script for the third step and I would like you to help me with three modifications : 
1) I seems that if the first word is an abbreviation, the script will match to an address that start with the same but ignore the rest of the address. For example, "F.Bernierstraat 1060" was matched to "Frankrijkstraat 1060". Can we make sure that all tokens match?
2) Some addresses also use - or .- in the abbreviations, for example "O.-L.-Vrouwstraat 3550" should match with "Onze Lieve Vrouwstraat 3550". Can you amend the part that matches abbrevations to treat "-" as well?
3) the last issue I have is that usual street word abbreviations are treated properly in the first step, but if there is a name abbreviation, it will not work in the whole process. Can you add in the script to use expand_address from libpostal and try to match by going through the list of addresses that result ?

I only need you to amend the provided code for step 3, I don't need you to provide anything for step 1 and 2 as they already work as intended

the script : 

# Function to match abbreviations (multiple letters allowed)
def match_abbreviation(token, referential_word):
    abbreviation_match = re.match(r'^([A-Za-zéèêëïîôöùüçÉÈÊËÏÎÔÖÙÜÇ]+)\.$', token)
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
            if match_address(client_address, referential_tokens):
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

print()
print(f"{round(len(matched_addresses_df[(matched_addresses_df['kl_country']!='BE') | (~matched_addresses_df['normalised_street'].isna()) ])/len(matched_addresses_df) * 100, 2)}% match")
#
