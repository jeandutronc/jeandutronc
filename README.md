def parse_full_address(df, street_col, city_col, postcode_col, country_col):
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
        for value, component  in parsed:
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

# Parse addresses in accounts dataframe
accounts_main_dataframe = parse_full_address(accounts_main_dataframe, 'BillingStreet', 'BillingCity', 'BillingPostalCode', 'BillingCountryCode')
accounts_main_dataframe = parse_full_address(accounts_main_dataframe, 'ShippingStreet', 'ShippingCity', 'ShippingPostalCode', 'ShippingCountryCode')

# Parse addresses in contacts dataframe
contacts_main_dataframe = parse_full_address(contacts_main_dataframe, 'OtherStreet', 'OtherCity', 'OtherPostalCode', 'OtherCountryCode')
contacts_main_dataframe = parse_full_address(contacts_main_dataframe, 'MailingStreet', 'MailingCity', 'MailingPostalCode', 'MailingCountryCode')
