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
    'OtherStreet': ['234 rue du tilleul', 'avenue beige 37'],
    'OtherCity': ['Liege', 'Namur'],
    'OtherPostalCode': ['4000', '5000'],
    'OtherCountryCode': ['BE', 'BE'],
    'MailingStreet': ['345 chemin du boulet', 'allée du berceau 890'],
    'MailingCity': ['Mons', 'Charleroi'],
    'MailingPostalCode': ['7000', '6000'],
    'MailingCountryCode': ['BE', 'BE']
})

# Address types
address_types_accounts = ['Billing', 'Shipping']
address_types_contacts = ['Other', 'Mailing']

# Columns for each address type in the accounts and contacts DataFrames
accounts_street_cols = ['BillingStreet', 'ShippingStreet']
accounts_city_cols = ['BillingCity', 'ShippingCity']
accounts_postcode_cols = ['BillingPostalCode', 'ShippingPostalCode']
accounts_country_cols = ['BillingCountryCode', 'ShippingCountryCode']

contacts_street_cols = ['OtherStreet', 'MailingStreet']
contacts_city_cols = ['OtherCity', 'MailingCity']
contacts_postcode_cols = ['OtherPostalCode', 'MailingPostalCode']
contacts_country_cols = ['OtherCountryCode', 'MailingCountryCode']

# Parse addresses in accounts dataframe
accounts_main_dataframe = parse_full_address(
    accounts_main_dataframe, address_types_accounts, accounts_street_cols, 
    accounts_city_cols, accounts_postcode_cols, accounts_country_cols
)

# Parse addresses in contacts dataframe
contacts_main_dataframe = parse_full_address(
    contacts_main_dataframe, address_types_contacts, contacts_street_cols, 
    contacts_city_cols, contacts_postcode_cols, contacts_country_cols
)
