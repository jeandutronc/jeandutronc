data_address = [
    ["123 Main St", "New York", "10001", "file1", "123 Main St, New York, NY 10001", ["123 Main Street, New York, NY 10001", "123 Main St, NYC, 10001"]],
    ["456 Elm St", "Chicago", "60611", "file2", "456 Elm St, Chicago, IL 60611", ["456 Elm Street, Chicago, IL 60611", "456 Elm St, Chi, 60611"]],
    ["789 Oak St", "Los Angeles", "90012", "file3", "789 Oak St, Los Angeles, CA 90012", ["789 Oak Street, Los Angeles, CA 90012", "789 Oak St, LA, 90012"]]
]


columns_address = ["street", "city", "postcode", "origin_file", "address", "expanded_address"]


df_address = pd.DataFrame(data_address, columns=columns_address)


# Create the second dataframe df
data = [
    ["PSP1", "Main St", "123", "Box 1", "10001", "New York", "USA", "123 Main St, New York, NY 10001", ["123 Main Street, New York, NY 10001", "123 Main St, NYC, 10001"]],
    ["PSP2", "Elm St", "456", "Box 2", "60611", "Chicago", "USA", "456 Elm St, Chicago, IL 60611", ["456 Elm Street, Chicago, IL 60611", "456 Elm St, Chi, 60611"]],
    ["PSP3", "Oak St", "789", "Box 3", "90012", "Los Angeles", "USA", "789 Oak St, Los Angeles, CA 90012", ["789 Oak Street, Los Angeles, CA 90012", "789 Oak St, LA, 90012"]]
]


columns = ["psp", "kl_street_name", "kl_street_number", "kl_box_number", "kl_postcode", "kl_city", "kl_country", "address", "expanded_address"]

df = pd.DataFrame(data, columns=columns)


counter=0

def match_address(client_country_code, client_zipcode, client_expanded_address, df_address):
    if client_country_code != 'BE':
        return (None, None, None, None)
    filtered_df = df_address[df_address['postcode'].str.startswith(client_zipcode[:2])]
    matches = filtered_df[filtered_df['expanded_address'].apply(lambda x: any(addr in x for addr in client_expanded_address))]
    if not matches.empty:
        return matches.iloc[0][['street', 'city', 'postcode', 'origin_file']].values
    return (None, None, None, None)

def process_client_row(row):
    global counter
    counter += 1
    print(f"Processed {counter} rows...", end='\r')
    return match_address(row['kl_country'], row['kl_postcode'], row['expanded_address'], df_address)

result = df.apply(process_client_row, axis=1, result_type='expand')
df[['matched_street', 'matched_city', 'matched_postcode', 'matched_file']] = result
print()
print(f"Processed {counter} rows in total.")
