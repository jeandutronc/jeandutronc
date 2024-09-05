import pandas as pd

# Preprocessing: Group addresses by first 2 digits of the postal code
df_address['postcode_prefix'] = df_address['postcode'].str[:2]
address_groups = df_address.groupby('postcode_prefix')

# Function to match address
def match_address_optimized(client_country_code, client_zipcode, client_expanded_address, address_groups):
    if client_country_code != 'BE':
        return (None, None, None, None)
    
    postcode_prefix = client_zipcode[:2]
    if postcode_prefix not in address_groups.groups:
        return (None, None, None, None)
    
    # Filter the relevant address group based on the postcode prefix
    filtered_df = address_groups.get_group(postcode_prefix)
    
    # Convert expanded_address lists to sets for fast lookup
    for _, address_row in filtered_df.iterrows():
        if set(client_expanded_address).intersection(set(address_row['expanded_address'])):
            return address_row[['street', 'city', 'postcode', 'origin_file']].values
    
    return (None, None, None, None)

# Processing function (without global variables)
def process_client_row_optimized(row):
    return match_address_optimized(row['kl_country'], row['kl_postcode'], row['expanded_address'], address_groups)

# Apply the optimized processing function to the dataframe
result = df.apply(process_client_row_optimized, axis=1, result_type='expand')
df[['matched_street', 'matched_city', 'matched_postcode', 'matched_file']] = result
