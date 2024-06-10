data = {'kl_first_name':['Antoine','An','Vanderelst'],
        'kl_last_name':['Vanderelst','Vanderelst','Vanderelst']}

df = pd.DataFrame(data)

def fn_ACCU_obs_InfoAlsoInOtherField_FirstLastName(row,field_name):
    if field_name == 'kl_first_name':   
        field1 = row['kl_first_name']
        field2 = row['kl_last_name']
    else:
        field1 = row['kl_last_name']
        field2 = row['kl_first_name']  
       
    if pd.isna(field1) or pd.isna(field2):
        return False
    
    field1_words = re.sub(" +", " ",str(field1)).strip().upper.split(" ")
    field2_words = re.sub(" +", " ",str(field1)).strip().upper.split(" ")
    
    for word1 in field1_words:
        for word2 in field2_words:
            if word1 in word2:
                return True
    return False

df.apply(fn_ACCU_obs_InfoAlsoInOtherField_FirstLastName,axis=1,field_name = 'kl_first_name')
