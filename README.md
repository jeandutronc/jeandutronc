def fn_CONF_obs_IncorrectIdentifier(dataframe, field_name):
    if dataframe['kl_country']=='BE':
        cc='BE'
    elif dataframe['kl_nationality']=='BE':
        cc='BE'
    elif dataframe['countryofactivity']=='BE':
        cc='BE'
    else:
        cc= None
    
    if cc=='BE':
        if field_name == 'kl_ben' and ataframe[field_name].str.len() !=9:
            return True
        elif field_name == 'kl_lei' and ataframe[field_name].str.len() !=9:
            return True
        elif field_name == 'kl_vat_number' and ataframe[field_name].str.len() !=10:
            return True
        else:
            return False
    else:
        return False
    
