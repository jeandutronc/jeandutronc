from postal.parser import parse_address
import pandas as pd
from difflib import SequenceMatcher


def parse_full_address(df, street_col, city_col, postcode_col, country_col):
    """
    Combines address fields into a full address, parses it using the postal package, 
    and extracts structured components.
    """
    df['full_address'] = (
        df[street_col].fillna('') + ', ' +
        df[city_col].fillna('') + ', ' +
        df[postcode_col].fillna('') + ', ' +
        df[country_col].fillna('')
    )
    
    parsed_addresses = df['full_address'].apply(parse_address)
    
    # Initialize columns for structured address components
    df['parsed_street'] = None
    df['parsed_postcode'] = None
    df['parsed_city'] = None
    df['parsed_country'] = None

    for idx, parsed in enumerate(parsed_addresses):
        for component, value in parsed:
            if component == 'house_number':
                continue  # Ignore house numbers
            elif component == 'road':
                df.at[idx, 'parsed_street'] = value
            elif component == 'postcode':
                df.at[idx, 'parsed_postcode'] = value
            elif component == 'city':
                df.at[idx, 'parsed_city'] = value
            elif component == 'country':
                df.at[idx, 'parsed_country'] = value

    return df


def similar(a, b):
    """Calculate similarity ratio between two strings."""
    return SequenceMatcher(None, a, b).ratio()


def match_addresses(accounts_df, contacts_df):
    """
    Match addresses between the accounts and contacts dataframes
    based on similarity of structured address components.
    """
    matches = []

    for acc_idx, acc_row in accounts_df.iterrows():
        for con_idx, con_row in contacts_df.iterrows():
            # Compare parsed components for similarity
            street_sim = similar(acc_row['parsed_street'], con_row['parsed_street'])
            city_sim = similar(acc_row['parsed_city'], con_row['parsed_city'])
            postcode_sim = acc_row['parsed_postcode'] == con_row['parsed_postcode']
            country_sim = acc_row['parsed_country'] == con_row['parsed_country']

            # Set thresholds for matches
            if street_sim > 0.8 and city_sim > 0.8 and postcode_sim and country_sim:
                matches.append({
                    'Account Index': acc_idx,
                    'Contact Index': con_idx,
                    'Account Address': acc_row['full_address'],
                    'Contact Address': con_row['full_address'],
                    'Street Similarity': street_sim,
                    'City Similarity': city_sim
                })

    return pd.DataFrame(matches)


# Input DataFrames
accounts_main_dataframe = pd.DataFrame({
    'BillingStreet': ['123 Main St', '456 Elm St'],
    'BillingCity': ['Brussels', 'Antwerp'],
    'BillingPostalCode': ['1000', '2000'],
    'BillingCountryCode': ['BE', 'BE'],
    'ShippingStreet': ['789 Oak St', '101 Pine St'],
    'ShippingCity': ['Ghent', 'Leuven'],
    'ShippingPostalCode': ['9000', '3000'],
    'ShippingCountryCode': ['BE', 'BE']
})

contacts_main_dataframe = pd.DataFrame({
    'OtherStreet': ['234 Maple St', '678 Cedar St'],
    'OtherCity': ['Liege', 'Namur'],
    'OtherPostalCode': ['4000', '5000'],
    'OtherCountryCode': ['BE', 'BE'],
    'MailingStreet': ['345 Birch St', '890 Spruce St'],
    'MailingCity': ['Mons', 'Charleroi'],
    'MailingPostalCode': ['7000', '6000'],
    'MailingCountryCode': ['BE', 'BE']
})

# Parse addresses in accounts dataframe
accounts_main_dataframe = parse_full_address(accounts_main_dataframe, 'BillingStreet', 'BillingCity', 'BillingPostalCode', 'BillingCountryCode')
accounts_main_dataframe = parse_full_address(accounts_main_dataframe, 'ShippingStreet', 'ShippingCity', 'ShippingPostalCode', 'ShippingCountryCode')

# Parse addresses in contacts dataframe
contacts_main_dataframe = parse_full_address(contacts_main_dataframe, 'OtherStreet', 'OtherCity', 'OtherPostalCode', 'OtherCountryCode')
contacts_main_dataframe = parse_full_address(contacts_main_dataframe, 'MailingStreet', 'MailingCity', 'MailingPostalCode', 'MailingCountryCode')

# Match addresses
matches_df = match_addresses(accounts_main_dataframe, contacts_main_dataframe)

# Output results
print("Matched Addresses:")
print(matches_df)
