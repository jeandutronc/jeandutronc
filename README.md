import re

# Function to match abbreviations
def match_abbreviation(token, referential_word):
    abbreviation_match = re.match(r'^([A-Za-z])\.$', token)
    if abbreviation_match:
        return referential_word.startswith(abbreviation_match.group(1))
    return False

# Function to normalize and compare addresses
def match_address(client_address, referential_address):
    client_tokens = client_address.split()  # Tokenize the client address
    referential_tokens = referential_address.split()  # Tokenize the referential address
    
    for client_token, referential_token in zip(client_tokens, referential_tokens):
        # Handle abbreviations
        if '.' in client_token:
            if not match_abbreviation(client_token, referential_token):
                return False  # Return False if abbreviation doesn't match
        else:
            # Handle full word matches
            if client_token.lower() != referential_token.lower():
                return False  # Return False if full words don't match
    
    return True  # All tokens matched

# Example usage
client_address = "Pr. Elizabethln"
referential_address = "Princes Elizabethlaan"

if match_address(client_address, referential_address):
    print("Match found!")
else:
    print("No match.")
