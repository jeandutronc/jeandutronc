unique_vnreli_codes = set([vnreli for vnreli, family_row, _ in all_family_data])

# Iterate over each vnreli code and compute the maximum family size for that code
for vnreli in unique_vnreli_codes:
    # Filter the families that belong to the current vnreli code
    families_for_vnreli = [family_row for code, family_row, _ in all_family_data if code == vnreli]
    
    # Calculate the maximum family size for this vnreli
    max_family_size = max(len(family) - 1 for family in families_for_vnreli)  # Subtract 1 to ignore vnreli itself
    
    # Print the result
    print(f"Max family size for code {vnreli}: {max_family_size}")
