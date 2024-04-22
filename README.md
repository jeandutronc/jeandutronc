# run command dws first then import package
# commands below will throw error, copy and run in another cell
#pip install phonenumbers

pip install phonenumbers

import pandas as pd
import os
from datetime import datetime
import numpy as np
import warnings
import re
import phonenumbers as pn # Version: 8.13.33
from phonenumbers.phonenumberutil import region_code_for_number
from phonenumbers.phonenumberutil import country_code_for_region


# Configure parameters

path = 'C:\\Users\\f25552\\OneDrive - BNP Paribas\\Documents\\CIVA\\2024\\data\\'

segment = 'PP'   # PP = Physical persons, IP = Independent professions, LE = Legal entities
type_person = '2' if segment == 'LE' else '1'

warnings.filterwarnings("ignore")

pd.set_option('display.max_columns', None)

age_cut_off = 115

# Import dataset

filename = 'sample_2024.txt'
pd.read_csv(path+filename, sep="\t",dtype=str)

filename = 'sample_2024.txt'

main_dataframe = pd.read_csv(path+filename, sep="\t",dtype=str)

main_dataframe = main_dataframe[main_dataframe['kl_type_person']==type_person]
main_dataframe = main_dataframe.reset_index()
main_dataframe = main_dataframe.drop(columns=['index'])

# Postal code format

# regex format for postal codes
# needs to be added before functions are applied
#path = '/domino/datasets/local/CIVA/'
filename = 'REF_PostalCode_format.xlsx'

post_codes = pd.read_excel(path+filename, sheet_name='sheet1')

grouped_post_codes = post_codes.groupby('ISO3166-1')['regex'].agg(lambda x:[f"'{pattern}'" for pattern in x]).reset_index()


transform_df = post_codes.groupby('ISO3166-1')['Transform_rules'].max().reset_index()
grouped_post_codes = pd.merge(grouped_post_codes,transform_df,on='ISO3166-1',how='inner')

def remove_apostrophe(lst):
        if isinstance(lst,list):
            return [str(item).replace("'","") for item in lst if isinstance(item,str)]
        else:
            return lst

grouped_post_codes['regex'] = grouped_post_codes['regex'].apply(remove_apostrophe)

main_dataframe = pd.merge(main_dataframe,grouped_post_codes,left_on='kl_country',right_on='ISO3166-1',how='left')

# Create birth date from day + month + year

main_dataframe['kl_birth_date'] = main_dataframe['kl_birth_date_year']+r'/'+main_dataframe['kl_birth_date_month']+r'/'+main_dataframe['kl_birth_date_day']

# Import functions

%run -i CIVA_Function.ipynb

# Import framework

filename = 'CIVA - Control Framework.xlsx'
sheetname = "Framework - "+segment

framework_dataframe = pd.read_excel(path+filename, sheet_name=sheetname)

# Run controls

#Prepare dataframe :
#remove uncontrolled fields
#melt to a 2 column format
#remove controls not run per field

framework_dataframe = framework_dataframe[framework_dataframe['To Control']==1]
framework_dataframe = framework_dataframe.drop(columns = ['Comment','To Control'])
framework_list = pd.melt(framework_dataframe, id_vars=['Fields','Format'],var_name='to_run_control',value_name='column_value')
framework_list = framework_list[framework_list['column_value'] == 1]

#%%capture
# main loop executing all controls

output_df = main_dataframe['psp']
output_df = pd.DataFrame(output_df)
start_time_full = datetime.now()
ctrl_nb = 1

for index, row in framework_list.sort_values('Fields').iterrows():
    
    start_time = datetime.now()
    
    field = row['Fields']
    control = row['to_run_control']
    input_format = row['Format']
    
    work_framework = framework_dataframe[framework_dataframe['Fields'] ==field]
    output_field_name = control+'_'+field
    output_df[output_field_name] =   fn_run_all_functions(
                                            field_name = field,
                                            input_df = main_dataframe, 
                                            output_df = output_df,
                                            to_run_framework = work_framework,
                                            control_name=control
                                            )
    end_time = datetime.now()
    print(str(ctrl_nb)+': '+control+' for '+field+ ' started at '+str(start_time.replace(microsecond=0)) +', done in '+str(round((end_time-start_time).total_seconds(),2))+'s')
    
    ctrl_nb = ctrl_nb+1
    
end_time_full = datetime.now()
print('Ran '+str(ctrl_nb-1)+' controls in '+str(round((end_time_full-start_time_full).total_seconds(),2))+'s')

#output_df[output_df['CONS_obs_RiskLevelUnderEvaluated_kl_nacebel']!=False]
#output_df['CONS_obs_RiskLevelUnderEvaluated for kl_nacebel']

field 
#kl_city
control 
#CONF_obs_MissingVowel

# test

test = main_dataframe[main_dataframe['psp'] == '540']
#pd.merge(main_dataframe,grouped_post_codes,left_on='kl_country',right_on='ISO3166-1',how='left')
pd.to_datetime(test['kl_birth_date'],format = '%Y/%m/%d',errors='coerce').isna()








1
import pandas as pd
2
import re
1
def fn_run_all_functions(field_name, input_df, output_df, to_run_framework, control_name):
2
    
3
    # Completeness
4
    
5
    if control_name == 'COMP_obs_ExclNAN':
6
        return fn_COMP_obs_ExclNAN(input_df[field_name])
7
    
8
    elif control_name == 'COMP_obs_NaN':
9
        return fn_COMP_obs_NaN(input_df[field_name])
10
​
11
    elif control_name == 'COMP_obs_WhiteSpace':
12
        return fn_COMP_obs_WhiteSpace(input_df[field_name])    
13
    
14
    elif control_name == 'COMP_obs_Blank':
15
        return fn_COMP_obs_Blank(input_df[field_name])    
16
    
17
    
18
    
19
    # Validity
20
    
21
    elif control_name == 'VALI_obs_ErrorDate':
22
        return fn_VALI_obs_ErrorDate(input_df[field_name],input_format = to_run_framework['Format'].to_string(index=False))
23
    
24
    elif control_name == 'VALI_obs_FutureDate':
25
        return fn_VALI_obs_FutureDate(input_df[field_name],to_run_framework['Reference File'].iloc[0]) 
26
    
27
    elif control_name == 'VALI_obs_NoForeignKey':
28
        return fn_VALI_obs_NoForeignKey(input_df[field_name], field_name, to_run_framework['Reference File'].iloc[0])  
29
    
30
    
31
    # Conformity
32
    
33
    elif control_name == 'CONF_obs_ContainSymbol':
34
        return fn_CONF_obs_ContainSymbol(input_df[field_name], field_name)   
35
    
36
    elif control_name == 'CONF_obs_LengthFallShort':
37
        return fn_CONF_obs_LengthFallShort(input_df[field_name], length = to_run_framework['Min. length'].to_string(index=False))
38
    
39
    elif control_name == 'CONF_obs_LengthExceed':
40
        return fn_CONF_obs_LengthExceed(input_df[field_name], length = to_run_framework['Max. length'].to_string(index=False))    
41
​
42
    elif control_name == 'CONF_obs_ContainRepetitionThreeAlphaCharacter':
43
        return fn_CONF_obs_ContainRepetitionThreeAlphaCharacter(input_df[field_name])
44
    
45
    elif control_name == 'CONF_obs_ContainRepetitionFourAlphaCharacter':
46
        return fn_CONF_obs_ContainRepetitionFourAlphaCharacter(input_df[field_name])
47
    
48
    elif control_name == 'CONF_obs_ContainLetter':
49
        return fn_CONF_obs_ContainLetter(input_df[field_name])
50
    
51
    elif control_name == 'CONF_obs_ContainNumber':
52
        return fn_CONF_obs_ContainNumber(input_df[field_name])
53
    
54
    elif control_name == 'CONF_obs_MissingVowel':
55
        return fn_CONF_obs_MissingVowel(input_df[field_name])
56
    
57
    elif control_name == 'CONF_obs_OnlyInitial':
58
        return fn_CONF_obs_OnlyInitial(input_df[field_name])
59
​
60
    elif control_name == 'CONF_obs_IncorrectIDcardNumber':
61
        return input_df.apply(fn_CONF_obs_IncorrectIDcardNumber,axis=1)
62
    
63
    elif control_name == 'CONF_obs_IncorrectNRN':
64
        return input_df.apply(fn_CONF_obs_IncorrectNRN,axis=1)
65
​
66
    elif control_name == 'CONF_obs_IncorrectEmail':   
67
        return input_df[field].apply(fn_CONF_obs_IncorrectEmail)
68
        
69
        
70
    # Accuracy
71
    
72
    elif control_name == 'ACCU_obs_AgeCutOffValue':
73
        return input_df[field_name].apply(fn_ACCU_obs_AgeCutOffValue,format = to_run_framework['Format'].to_string(index=False))
74
    
75
    elif control_name == 'ACCU_obs_NoPhoneNumber':
76
        return input_df.apply(fn_ACCU_obs_NoPhoneNumber,axis=1,args=(field_name,))
77
    
78
    elif control_name == 'ACCU_obs_IssuePostCodeFormat':
79
        return input_df.apply(fn_ACCU_obs_IssuePostCodeFormat,axis=1,args=(field_name,))  
80
​
81
    elif control_name == 'ACCU_obs_InfoAlsoInOtherField_FirstLastName':
82
        return input_df.apply(fn_ACCU_obs_InfoAlsoInOtherField_FirstLastName,axis=1,args=(field_name,))  
83
    
84
    elif control_name == 'ACCU_obs_ContainPOboxNumber':
85
        return input_df.apply(fn_ACCU_obs_ContainPOboxNumber,axis=1,args=(field_name,))      
86
    
87
    
88
    
89
    # Consistency
90
    
91
    elif control_name == 'CONS_obs_RiskLevelUnderEvaluated':
92
        return fn_CONS_obs_RiskLevelUnderEvaluated(input_df, field_name, to_run_framework['Reference File'].iloc[0])
93
    
94
    
95
    # Integrity
96
    
97
    elif control_name == 'INTE_obs_InconsistentWithFATCAflag':
98
        return fn_INTE_obs_InconsistentWithFATCAflag(input_df,field_name)    
99
    
100
    
101
    # Uniqueness
102
    
103
    elif control_name == 'UNIQ_obs_IsDuplicated':
104
        return fn_UNIQ_obs_IsDuplicated(input_df[field_name])     
105
    
106
    elif control_name == 'UNIQ_obs_DupSurnameForenameDoB':
107
        return fn_UNIQ_obs_DupSurnameForenameDoB(input_df)  
108
    
109
    elif control_name == 'UNIQ_obs_DupNameConstitutionDate':
110
        return fn_UNIQ_obs_DupNameConstitutionDate(input_df)  
111
    
112
    elif control_name == 'UNIQ_obs_DulicateGovIdDiffName':
113
        return fn_UNIQ_obs_DulicateGovIdDiffName(input_df,field_name) 
114
    
115
    
116
    #Risk
117
    
118
    elif control_name == 'RISK_obs_Sensitivity_VeryHigh':
119
        return fn_RISK_obs_Sensitivity_VeryHigh(input_df,field_name,to_run_framework['Reference File'].iloc[0]) 
120
    
121
    elif control_name == 'RISK_obs_Sensitivity_High':
122
        return fn_RISK_obs_Sensitivity_High(input_df,field_name,to_run_framework['Reference File'].iloc[0])  
123
    
124
    elif control_name == 'RISK_obs_Sensitivity_Medium':
125
        return fn_RISK_obs_Sensitivity_Medium(input_df,field_name,to_run_framework['Reference File'].iloc[0])
126
    
127
    
128
    
129
    
130
    
131
    else:
132
        raise ValueError(f"Unknown Control : {control_name}")
133
    
Completeness
COMP_obs_ExclNAN
1
# check if the field is not NULL
2
def fn_COMP_obs_ExclNAN(field):
3
    return field == field
COMP_obs_NaN
1
# check if the field is NULL
2
def fn_COMP_obs_NaN(field):
3
    return field.isna()
COMP_obs_WhiteSpace
1
# check if the field is NULL
2
def fn_COMP_obs_WhiteSpace(field):
3
    result = np.where(field.isna(),False,field.str.strip() != field)
4
    result = pd.DataFrame(result)
5
    return result
COMP_obs_Blank
1
# check if the field is empty
2
def fn_COMP_obs_Blank(field):
3
    return field == ''
Validity
VALI_obs_ErrorDate
1
# check if date follows the format provided in the framework
2
def fn_VALI_obs_ErrorDate(field,input_format):
3
    result = np.where(field.isna(),
4
             False,
5
             np.where(pd.to_datetime(field,format = input_format,errors='coerce').isna(),
6
                  True,
7
                  False))
8
    pd.DataFrame(result)
9
    return result
VALI_obs_FutureDate
# check if date is in the future
def fn_VALI_obs_FutureDate(field,input_format):
    current_date = datetime.now()
    return np.where(pd.to_datetime(field,format = input_format,errors='coerce') > current_date
1
# check if date is in the future
2
def fn_VALI_obs_FutureDate(field,input_format):
3
    current_date = datetime.now()
4
    return np.where(pd.to_datetime(field,format = input_format,errors='coerce') > current_date
VALI_obs_NoForeignKey
1
# check if value is missing from list (each value a different list)
2
​
3
​
4
def fn_VALI_obs_NoForeignKey(field, field_name, reference_file_name):
5
    sheet_name = 'sheet1'
6
    
7
    ref_file = pd.read_excel(path+reference_file_name, sheet_name=sheet_name,dtype=str)
8
    
9
    return field.apply(fn_VALI_obs_NoForeignKey_sub_function,args=[ref_file,field_name])#,axis=1)
10
​
11
​
12
# sub-function to check at field level
13
def fn_VALI_obs_NoForeignKey_sub_function(field,ref_file,field_name):
14
    if pd.isna(field):
15
        return False
16
    else:
17
        if field_name == 'sectorofactivity':
18
            return field[:4] not in ref_file['Code'].values
19
        else : 
20
            return  field not in ref_file['Code'].values
Conformity
CONF_obs_LengthFallShort
1
# check if field respects minimum length requirement
2
def fn_CONF_obs_LengthFallShort(field, length):
3
    return field.str.len() < float(length)
CONF_obs_LengthExceed
1
# check if field respects maximum length requirement
2
def fn_CONF_obs_LengthExceed(field, length):
3
    return field.str.len() > float(length)
CONF_obs_ContainRepetitionThreeAlphaCharacter
1
# check if field contains the same character 3 times in a row
2
def fn_CONF_obs_ContainRepetitionThreeAlphaCharacter(field):
3
    return ~field.astype(str).str.contains(r'(.)\1{2}',regex=True)
CONF_obs_ContainRepetitionFourAlphaCharacter
1
# check if field contains the same character 4 times in a row
2
def fn_CONF_obs_ContainRepetitionFourAlphaCharacter(field):
3
    return ~field.astype(str).str.contains(r'(.)\1{3}',regex=True)
CONF_obs_ContainSymbol
1
# check if field contains a character from the list
2
def fn_CONF_obs_ContainSymbol(field, field_name):
3
​
4
    default_list_symbols = ["-","[","]",",","@","_","!","#","$","%","^","&","*","(",")","<",">","?","/","|","}","{","~",":","©"]
5
    
6
    if field_name == 'kl_last_name':
7
        exclude_value = [".","'","-"]
8
    if field_name == 'kl_first_name':
9
        exclude_value = [".","'","-"]
10
    elif field_name == 'kl_street_name':
11
        exclude_value = ["-","[","]",",","@","_","!","#","$","%","^","&","(",")","?","/","|","}","{","~","©"]
12
    elif field_name == 'kl_city':
13
        exclude_value = [".","'","-", "(",")", ",", "/" ]
14
    else: exclude_value = ['']
15
    symbols = [element for element in default_list_symbols if element not in exclude_value]
16
    symbols = [re.escape(symbol) for symbol in symbols]
17
    
18
    return field.str.contains('|'.join(symbols)).fillna(False)
CONF_obs_ContainLetters
1
# check if field contains anything that is not a number or "/" "\" "+" "(" ")" or a space
2
def fn_CONF_obs_ContainLetter(field):
3
    return field.str.contains(r'[^0-9\+\\\/\(\) ]',regex=True)
CONF_obs_ContainNumber
1
# check if field contains a number
2
def fn_CONF_obs_ContainNumber(field):
3
    return field.str.contains(r'\d',regex=True)
CONF_obs_MissingVowel
1
# check if field does not contain vowels
2
def fn_CONF_obs_MissingVowel(field):
3
        return ~main_dataframe['kl_city'].str.contains(r'[aeiouyAEIOUY]',regex=True).fillna(False)
CONF_obs_OnlyInitial
1
# check if field contains only initials (examples : 'A.','B.B','B B.','B B')
2
def fn_CONF_obs_OnlyInitial(field):
3
    return  field.isna() |  ~field.str.contains(r'\b[A-Za-z]{2,}\b',regex=True).fillna(True)#
CONF_obs_IncorrectIDcardNumber
1
# check for BE nationals if the ID card number is 12 characters and if modulus 97 validation is correct
2
def fn_CONF_obs_IncorrectIDcardNumber(row):
3
    
4
    if pd.isna(row['kl_identity_card']):
5
            idnummer_check = False
6
    elif any(char.isdigit() ==False for char in str(row['kl_identity_card'])):
7
        return True
8
    elif row['kl_nationality'] =='BE':
9
        if  len(str(row['kl_identity_card'])) == 12:
10
            if  int(str(row['kl_identity_card'])[:10]) % 97 ==  int(str(row['kl_identity_card'])[10:12]):
11
                        idnummer_check = False
12
            elif int(str(row['kl_identity_card'])[:10]) % 97 == 0 and int(str(row['kl_identity_card'])[10:12]) == 97:
13
                        idnummer_check = False
14
            else: idnummer_check = True
15
        else:
16
            idnummer_check = True        
17
    else:
18
        idnummer_check =   False
19
    return idnummer_check
CONF_obs_IncorrectNRN
1
# check for BE nationals if the ID card number is 12 characters and if modulus 97 validation is correct
2
def fn_CONF_obs_IncorrectNRN(row):
3
    
4
    if pd.isna(row['kl_nrn']):
5
            idnummer_check = False
6
    elif row['kl_nationality'] =='BE':
7
        if  len(str(row['kl_nrn'])) == 11:
8
            if pd.to_datetime(row['kl_birthdate'],errors='coerce').year < 2000:   # formula different for people born after 2000
9
                if  int(str(row['kl_nrn'])[:8]) % 97 ==  int(str(row['kl_nrn'])[8:10]):  # first 9 characters divided by 97 should have a mod equal to last 2 characters
10
                    idnummer_check = False
11
                elif int('2'+str(row['kl_nrn'])[:8]) % 97 ==  int(str(row['kl_nrn'])[8:10]): # first 9 characters preceded by 2 divided by 97 should have a mod equal to last 2 characters
12
                    idnummer_check = False
13
                else:
14
                    idnummer_check = True
15
        else:
16
            idnummer_check = True        
17
    else:
18
        idnummer_check =   False
19
    return idnummer_check
CONF_obs_IncorrectEmail
1
# check if email address respects format
2
def fn_CONF_obs_IncorrectEmail(email):
3
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'   # "text123._%+-" + @ +  "text123.-" + "." + "text"
4
    if pd.isna(email):
5
        return False
6
    email = email.strip()
7
    return not bool(re.match(pattern,email))
Accuracy
ACCU_obs_AgeCutOffValue
# check that client is not older than age cut off value defined in main script
def fn_ACCU_obs_AgeCutOffValue(field,format):
    date = pd.to_datetime(field,format = input_format,errors='coerce')
    if pd.isna(date):
        return False
    else:
        age = datetime.now().year - date.year
        return age > age_cut_off
1
# check that client is not older than age cut off value defined in main script
2
def fn_ACCU_obs_AgeCutOffValue(field,format):
3
    date = pd.to_datetime(field,format = input_format,errors='coerce')
4
    if pd.isna(date):
5
        return False
6
    else:
7
        age = datetime.now().year - date.year
8
        return age > age_cut_off
ACCU_obs_NoPhoneNumber
1
# Check if phone number is valid. Use country fo residence, BE or trying parsing country from phone number for validation
2
def fn_ACCU_obs_NoPhoneNumber(row,field): 
3
    phone_number = row[field]
4
    country=row['kl_country']
5
    
6
    if pd.isna(phone_number):
7
        return False
8
    #1.01 : try using the country of residence as country cde
9
    try:
10
        parsenumber = pn.parse(phone_number,country)
11
        if pn.is_valid_number(parsenumber):
12
            return False
13
    except:
14
        pass
15
    
16
    #1.02 : try using BE as country code
17
    try:
18
        parsenumber = pn.parse(phone_number,'BE')
19
        if pn.is_valid_number(parsenumber):
20
            return False
21
    except:
22
        pass
23
    
24
    #1.03 : try using finding country code directly from number. E.g. +48500500500 -> Poland
25
    try:
26
        parsenumber = pn.parse(phone_number,None)
27
        if pn.is_valid_number(parsenumber):
28
            return False
29
    except:
30
        pass    
31
    return True
ACCU_obs_IssuePostCodeFormat
1
def check_regex(value, regex_patterns,transform_rule):
2
    if pd.isna(value) or pd.isna(regex_patterns).any():
3
        return False
4
    if transform_rule== 0:
5
        return value != str(regex_patterns[0])
6
    
7
    for pattern in regex_patterns:
8
        if re.fullmatch(pattern,value):
9
            return False
10
    return True
11
    
12
    
13
def fn_ACCU_obs_IssuePostCodeFormat(row,field_name):
14
    value = row[field_name]
15
    regex_patterns= row['regex']
16
    transform_rule = row['Transform_rules']
17
    
18
    if not isinstance(regex_patterns,list):
19
        regex_patterns=[regex_patterns]    
20
​
21
    return check_regex(value,regex_patterns,transform_rule)
ACCU_obs_ContainPOboxNumber
1
def fn_ACCU_obs_ContainPOboxNumber(row,field_name):
2
    po_box = row[field_name]
3
    street_name = row['kl_street_name']
4
    city_name = row['kl_city']
5
    
6
    if pd.isna(po_box):
7
        return False
8
    
9
    po_box_str = str(po_box)
10
    
11
    if po_box in str(street_name) or po_box_str in str(city_name):
12
        return True
13
    return False
ACCU_obs_InfoAlsoInOtherField_FirstLastName
1
def fn_ACCU_obs_InfoAlsoInOtherField_FirstLastName(row,field_name):
2
#     return False
3
    if field_name == 'kl_first_name':   
4
        field1 = row['kl_first_name']
5
        field2 = row['kl_last_name']
6
    else:
7
        field1 = row['kl_last_name']
8
        field2 = row['kl_first_name']  
9
       
10
    if pd.isna(field1) or pd.isna(field2):
11
        return False
12
    return field1.lower() in field2.lower()
Consistency
1
# check that the risk level is not under evaluated compared to the sensitivity level of the field
2
def fn_CONS_obs_RiskLevelUnderEvaluated(dataframe,field_name,ref_file_name):
3
    
4
    ref_file = pd.read_excel(path+ref_file_name, sheet_name='sheet1',dtype=str)
5
    
6
    if field_name == 'kl_nacebel':  
7
        risk_file_sheet_name = 'NACEBEL'
8
    elif field_name == 'pep':
9
        risk_file_sheet_name = 'PEP'
10
    elif field_name == 'sectorofactivity':
11
        risk_file_sheet_name = 'SectorOfActivity'
12
    elif field_name == 'countryofactivity':
13
        risk_file_sheet_name = 'Country'
14
    elif field_name == 'kl_country':
15
        risk_file_sheet_name = 'Country'
16
    elif field_name == 'kl_nationality':
17
        risk_file_sheet_name = 'Country'
18
        
19
    risk_file = pd.read_excel(path+'REF_RiskLevel_UnderEvaluated.xlsx', sheet_name= risk_file_sheet_name,dtype=str)
20
        
21
    risk_check_df = dataframe[['psp','party_risklevel',field_name]]
22
​
23
    risk_check_df = pd.merge(risk_check_df,ref_file,left_on=field_name,right_on='Code',how='left')
24
    risk_check_df = pd.merge(risk_check_df, risk_file, left_on = ['Risk Level','party_risklevel'], right_on = ['SensitivityScore','RiskLevel'],how='left')
25
    
26
    risk_check_df['UnderEvaluated_desc'] = risk_check_df['UnderEvaluated_desc'].map({'True':True,'False':False})
27
    risk_check_df['UnderEvaluated_desc'] = risk_check_df['UnderEvaluated_desc'].fillna(False)
28
    risk_check_df[risk_check_df['UnderEvaluated_desc']!=False]    
29
    return risk_check_df['UnderEvaluated_desc']
Integrity
1
# check that the fatca classification is filled for US nationals or residents
2
def fn_INTE_obs_InconsistentWithFATCAflag(dataframe,field_name):
3
    
4
    return dataframe[field_name].str.strip() == 'US' &  dataframe['kl_fatca_classif'].isna() 
Uniqueness
UNIQ_obs_IsDuplicated
1
# check if value is unique
2
def fn_UNIQ_obs_IsDuplicated(field):
3
​
4
    return field.duplicated(keep=False)
UNIQ_obs_DupSurnameForenameDoB
1
# Check that client is not duplicated on First Name + Last Name + Date of Birth
2
def fn_UNIQ_obs_DupSurnameForenameDoB(input_df):
3
​
4
    to_check = ['kl_first_name', 'kl_last_name', 'kl_birth_date']
5
​
6
    input_df['combi'] = input_df[to_check].fillna('').astype(str).apply('_'.join, axis=1)
7
​
8
    dupli = input_df['combi'].duplicated(keep = False)
9
​
10
    return dupli
UNIQ_obs_DupNameConstitutionDate
1
# check that company is not duplicated on Company Name + Consitution Date
2
def fn_UNIQ_obs_DupNameConstitutionDate(input_df):
3
​
4
    to_check = ['kl_company_name', 'kl_constitution_date']
5
​
6
    input_df['combi'] = input_df[to_check].fillna('').astype(str).apply('_'.join, axis=1)
7
​
8
    dupli = input_df['combi'].duplicated(keep = False)
9
​
10
    return dupli
UNIQ_obs_DulicateGovIdDiffName
1
# check that 2 clients with the same ID have the same name
2
def fn_UNIQ_obs_DulicateGovIdDiffName(input_df,field_name):
3
    
4
    # Highlight les doublons dans id_card
5
    duplicate_id_card = input_df[field_name].duplicated(keep=False)
6
    
7
    # Highlight quand le last_name est différent alors que même ID num
8
    anomalies = input_df[duplicate_id_card].groupby(field_name)['kl_last_name'].nunique() > 1
9
    
10
    #identifier les erreurs
11
    is_anomalie = input_df[field_name].isin(anomalies[anomalies].index)
12
    
13
    return is_anomalie
Risk
RISK_obs_Sensitivity_VeryHigh
1
# check that the risk level is not under evaluated compared to the sensitivity level of the field
2
def fn_RISK_obs_Sensitivity_VeryHigh(dataframe,field_name,ref_file_name):
3
    
4
    ref_file = pd.read_excel(path+ref_file_name, sheet_name='sheet1',dtype=str)
5
    
6
    sensitivity_df = dataframe[['psp',field_name]]
7
    sensitivity_df = pd.merge(sensitivity_df,ref_file,left_on=field_name,right_on='Code',how='left')
8
    
9
    return  sensitivity_df['Risk Level'].isin(['VHS','BAN'])
RISK_obs_Sensitivity_High
1
# check that the risk level is not under evaluated compared to the sensitivity level of the field
2
def fn_RISK_obs_Sensitivity_High(dataframe,field_name,ref_file_name):
3
    
4
    ref_file = pd.read_excel(path+ref_file_name, sheet_name='sheet1',dtype=str)
5
    
6
    sensitivity_df = dataframe[['psp',field_name]]
7
    sensitivity_df = pd.merge(sensitivity_df,ref_file,left_on=field_name,right_on='Code',how='left')
8
​
9
    return  ref_file['Risk Level'].isin(['HS','VHS','BAN'])
RISK_obs_Sensitivity_Medium
# check that the risk level is not under evaluated compared to the sensitivity level of the field
def fn_RISK_obs_Sensitivity_Medium(dataframe,field_name,ref_file_name):
    
    ref_file = pd.read_excel(path+ref_file_name, sheet_name='sheet1',dtype=str)
    
    sensitivity_df = dataframe[['psp',field_name]]
    sensitivity_df = pd.merge(sensitivity_df,ref_file,left_on=field_name,right_on='Code',how='left')

    return  ref_file['Risk Level'].isin(['MS','HS','VHS','BAN'])
1
# check that the risk level is not under evaluated compared to the sensitivity level of the field
2
def fn_RISK_obs_Sensitivity_Medium(dataframe,field_name,ref_file_name):
3
    
4
    ref_file = pd.read_excel(path+ref_file_name, sheet_name='sheet1',dtype=str)
5
    
6
    sensitivity_df = dataframe[['psp',field_name]]
7
    sensitivity_df = pd.merge(sensitivity_df,ref_file,left_on=field_name,right_on='Code',how='left')
8
​
9
    return  ref_file['Risk Level'].isin(['MS','HS','VHS','BAN'])
