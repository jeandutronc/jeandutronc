can you replace the country codes of this script :

check for BE nationals if the ID card number is 12 characters and if modulus 97 validation is correct
def check_passport(value, nationality): # Dictionary containing regex for each country passport format formats_dict_passeport = { 'DE': [r'^[CHJKLMNPRTVWXYZ]{1}[CFGHJKLMNPRTVWXYZ1-9]{8}$'], 'NL': [r'^[A-NP-Z]{2}[A-NP-Z1-9]{6}[0-9]{1}$'], 'BE': [r'^(?:[E]{1}[A-Z]{1}|[LD]{2}|[LA]{2}|[CE]{2})[0-9]{6}$'], 'FR': [r'^[0-9]{2}[A-Z]{2}[0-9]{5}$', r'^[0-9]{12}$'], 'TR': [r'^[A-Z]{1}[0-9]{8}$'], 'MA': [r'^[A-Z]{2}(?:[0-9]{7}|[0-9]{5})$'] }

# Get regex pattern list for each country 
regex_patterns = formats_dict_passeport.get(nationality, [])


# Check value compared to regex pattern
for pattern in regex_patterns:
    if re.fullmatch(pattern, value):
        # Si value correspond à un motif regex, renvoyer False (valide)
        return False

# Return True if no pattern found
return True

check if Id card nb respects the country format
def check_id_card(value, nationality): formats_dict_id_card = { 'AF':[r'^[A-Za-z]{2}\d{7}$',r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN, LLNNNNNNN 'AL':[r'^[A-Za-z]{2}\d{7}$',r'^\d{8}$'], #LLNNNNNNN, NNNNNNNN 'BD':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'BI':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'BL':[r'^\d{2}[A-Za-z]{2}\d{5}$'], #NNLLNNNNN 'CD':[r'^[A-Za-z]{2}\d{7}$',r'^\d{1}[A-Za-z]{2}\d{7}$'], #NLNNNNNNN, LLNNNNNNN 'CG':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'CI':[r'^\d{2}[A-Za-z]{2}\d{5}$'], #NNLLNNNNN 'CN':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'DJ':[r'^\d{2}[A-Za-z]{2}\d{5}$'], #NNLLNNNNN 'DZ':[r'^\d{1}[A-Za-z]{2}\d{7}$'], #NNLNNNNNN 'EG':[r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN 'ES':[r'^[A-Za-z]{1}\d{8}$',r'^\d{8}[A-Za-z]{1}$',r'^\d{6}$',r'^[A-Za-z]{2}\d{7}$',r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN, LLNNNNNNN 'GR':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'HU':[r'^\d{6}[A-Za-z]{2}$'], #NNNNNNLL 'ID':[r'^\d{8}$',r'^\d{6}$'], #NNNNNN, NNNNNNNN 'IE':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'IQ':[r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN 'IR':[r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN 'IT':[r'^[A-Za-z]{2}\d{5}[A-Za-z]{2}$',r'^[A-Za-z]{2}\d{7}$',r'^\d{6}$'], #NNNNNN, LLNNNNNNN 'JO':[r'^[A-Za-z]{1}\d{6}$'], #LNNNNNN 'LB':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'LV':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'MD':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'MG':[r'^[A-Za-z]{1}\d{2}[A-Za-z]{1}\d{5}$'], #LNNLNNNNN 'NE':[r'^[A-Za-z]{1}\d{8}$',r'^\d{2}[A-Za-z]{2}\d{5}$'], #NNLLNNNNN, LNNNNNNNN 'NG':[r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN 'NP':[r'^\d{8}$'], #NNNNNNNN 'PE':[r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN 'PH':[r'^[A-Za-z]{1}\d{7}[A-Za-z]{1}$'], #LNNNNNNNL 'PL':[r'^[A-Za-z]{2}\d{7}$'], #LLNNNNNNN 'PT':[r'^\d{9}[A-Za-z]{2}\d{1}$',r'^\d{8}$',r'^[A-Za-z]{1}\d{6}$'], #LNNNNNN, NNNNNNNN 'PY':[r'^[A-Za-z]{1}\d{6}$'], #LNNNNNN 'RO':[r'^[A-Za-z]{2}\d{6}$',r'\d{13}$',r'^\d{8}$'], #NNNNNNNN, NNNNNNNNNNNNN 'SE':[r'^\d{8}$'], #NNNNNNNN 'SV':[r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN 'TB':[r'^[A-Za-z]{1}\d{6}$'], #LNNNNNN 'US':[r'^\d{8}$'], #NNNNNNNN 'XK':[r'^[A-Za-z]{1}\d{8}$'], #LNNNNNNNN 'YE':[r'^\d{8}$'] #NNNNNNNN } # Get regex pattern list for each country regex_patterns = formats_dict_id_card.get(nationality, [])

# Check value compared to regex pattern
for pattern in regex_patterns:
    if re.fullmatch(pattern, value):
        # Si value correspond à un motif regex, renvoyer False (valide)
        return False

# Return True if no pattern found
return True

def fn_CONF_IncorrectIDcardNumber(dataframe, field_name,nationality_field,country_field): # Get value and nationality value = dataframe[field_name] nationality = dataframe[nationality_field] country = dataframe[country_field]

# check if value is NaN
if pd.isna(value):
    return False

# check for residentiel number
elif nationality in ['AF', 'AL', 'BD', 'BI', 'BL', 'CD', 'CG', 'CI', 'CN', 'DJ', 'DZ', 'EG', 'ES', 'GR', 'HU', 'ID', 'IE', 'IO', 'IR', 'IT', 'JO', 'LB', 'LV', 'MD', 'MG', 'NE', 'NG', 'NP', 'PE', 'PH', 'PL', 'PT', 'PY', 'RO', 'SE', 'SV', 'TB', 'US', 'XK', 'YE'] and (country == 'BE'):
    if value[:1] == 'B':
        if value[1:].isdigit(): # besides the firt CHAR need to be B the rest needs to be a int
            if len(value) == 10:
                return False
            else:
                return True

# check if belgian nationality (id_card) and exclude belgium passport from the check  
elif nationality == 'BE' and value[:1].isdigit():
    if pd.isna(value):
        return False
    if not value.isdigit():
        return True
    if  len(str(value)) == 12:
        if  int(str(value)[:10]) % 97 ==  int(str(value)[10:12]):
                    return False # card id valid
        elif int(str(value)[:10]) % 97 == 0 and int(str(value)[10:12]) == 97:
                    return False # card id valid
        else: return True # invalid
    else:
        return True  # invalid  
  
# check passport for the pattern we have excluded the residentiel number and exclude belgian ID_card
elif nationality in ['DE','NL','FR','BE','TR','MA'] and value[:1] != 'B' and value[:1].isalpha():
    return check_passport(value, nationality)

# check if nationality has a specific ID card format # CountryCodes_EUandEFTA_ExclBE
elif ((nationality != 'BE') and (country != 'BE')):
    return check_id_card(value, nationality)

else:
    return False
