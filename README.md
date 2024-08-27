#unique_codes = final_df['vnreli'].unique()
#
#with pd.ExcelWriter('C:\\Users\\f25552\\OneDrive - BNP Paribas\\Documents\\Python\\loops.xlsx',engine = 'openpyxl') as writer:
#    for code in unique_codes:
#        #filter on codes
#        df_per_code = final_df[final_df['vnreli']==code]
#        
#        #create families
#        G = nx.from_pandas_edgelist(df_per_code, source = 'psp_1',target='psp_2',create_using=nx.DiGraph)
#        
#        #locate families with loops
#        cycles = list(nx.simple_cycles(G))
#        
#        #create dataframe of those families
#        loop_df = pd.DataFrame(cycles)
#        if len(loop_df) == 0:
#            print(f'No loops for code {code}')
#        else:
#            loop_df.to_excel(writer,sheet_name=code,index=False)
#            print(f'saved {len(loop_df)} rows to sheet {code}')
#print('done')    
#
#
#
#



def create_families(df):
    families_with_loops = {}
    G = nx.from_pandas_edgelist(df, source='psp_1', target='psp_2', create_using=nx.DiGraph)
    cycles = list(nx.simple_cycles(G))
    if cycles:
        families_with_loops[vnreli] = list(nx.connected_components(G.to_undirected()))
    return families_with_loops

vnreli_values = final_df['vnreli'].unique()
df_families_with_loops = pd.DataFrame()

with pd.ExcelWriter('C:\\Users\\f25552\\OneDrive - BNP Paribas\\Documents\\Python\\IP_IP_{}.xlsx'.format(datetime.date.today().strftime('%Y%m%d')), engine='openpyxl') as writer:
    for vnreli in vnreli_values:
        df_per_code = final_df[final_df['vnreli'] == vnreli]
        family_with_loops_per_code = create_families(df_per_code)
        if family_with_loops_per_code :
            df_families_with_loop_per_code = pd.DataFrame(list(map(list, family_with_loops_per_code[vnreli])))
            df_families_with_loop_per_code.to_excel(writer,sheet_name=vnreli,index=False)
            print(f'saved {len(df_families_with_loop_per_code)} rows to sheet {vnreli}')
        else:
            print(f'No loops for code {vnreli}')
