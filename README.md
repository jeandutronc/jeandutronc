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

with the countries in this list Belgium;Luxembourg;Netherlands;France;Germany;Afghanistan;Aland Islands;Albania;Algeria;Andorra;Angola;Anguilla;Antarctica;Antigua and Barbuda;Argentina;Armenia;Aruba;Australia;Austria;Azerbaijan;Bahamas;Bahrain;Bangladesh;Barbados;Belarus;Belize;Benin;Bermuda;Bhutan;Bolivia, Plurinational State of;Bonaire, Sint Eustatius and Saba;Bosnia and Herzegovina;Botswana;Bouvet Island;Brazil;British Indian Ocean Territory;Brunei Darussalam;Bulgaria;Burkina Faso;Burundi;Cambodia;Cameroon;Canada;Cape Verde;Cayman Islands;Central African Republic;Chad;Chile;China;Christmas Island;Cocos (Keeling) Islands;Colombia;Comoros;Congo;Congo, the Democratic Republic of the;Cook Islands;Costa Rica;Cote d'Ivoire;Croatia;Cuba;Curaçao;Cyprus;Czech Republic;Denmark;Djibouti;Dominica;Dominican Republic;Ecuador;Egypt;El Salvador;Equatorial Guinea;Eritrea;Estonia;Ethiopia;Falkland Islands (Malvinas);Faroe Islands;Fiji;Finland;French Guiana;French Polynesia;French Southern Territories;Gabon;Gambia;Georgia;Ghana;Gibraltar;Greece;Greenland;Grenada;Guadeloupe;Guatemala;Guernsey;Guinea;Guinea-Bissau;Guyana;Haiti;Heard Island and McDonald Islands;Holy See (Vatican City State);Honduras;Hungary;Iceland;India;Indonesia;Iran, Islamic Republic of;Iraq;Ireland;Isle of Man;Israel;Italy;Jamaica;Japan;Jersey;Jordan;Kazakhstan;Kenya;Kiribati;Korea, Democratic People's Republic of;Korea, Republic of;Kosovo;Kuwait;Kyrgyzstan;Lao People's Democratic Republic;Latvia;Lebanon;Lesotho;Liberia;Libyan Arab Jamahiriya;Liechtenstein;Lithuania;Macao;Madagascar;Malawi;Malaysia;Maldives;Mali;Malta;Martinique;Mauritania;Mauritius;Mayotte;Mexico;Moldova, Republic of;Monaco;Mongolia;Montenegro;Montserrat;Morocco;Mozambique;Myanmar;Namibia;Nauru;Nepal;New Caledonia;New Zealand;Nicaragua;Niger;Nigeria;Niue;Norfolk Island;North Macedonia;Norway;Oman;Pakistan;Palestine;Panama;Papua New Guinea;Paraguay;Peru;Philippines;Pitcairn;Poland;Portugal;Qatar;Reunion;Romania;Russian Federation;Rwanda;Saint Barthélemy;Saint Helena, Ascension and Tristan da Cunha;Saint Kitts and Nevis;Saint Lucia;Saint Martin (French part);Saint Pierre and Miquelon;Saint Vincent and the Grenadines;Samoa;San Marino;Sao Tome and Principe;Saudi Arabia;Senegal;Serbia;Seychelles;Sierra Leone;Singapore;Sint Maarten (Dutch part);Slovakia;Slovenia;Solomon Islands;Somalia;South Africa;South Georgia and the South Sandwich Islands;South Sudan;Spain;Sri Lanka;Sudan;Suriname;Svalbard and Jan Mayen;Swaziland;Sweden;Switzerland;Syrian Arab Republic;Taiwan;Tajikistan;Tanzania, United Republic of;Thailand;Timor-Leste;Togo;Tokelau;Tonga;Trinidad and Tobago;Tunisia;Turkey;Turkmenistan;Turks and Caicos Islands;Tuvalu;Uganda;Ukraine;United Arab Emirates;United Kingdom;United States of America;Uruguay;Uzbekistan;Vanuatu;Venezuela, Bolivarian Republic of;Vietnam;Virgin Islands, British;Wallis and Futuna;Western Sahara;Yemen;Zambia;Zimbabwe
