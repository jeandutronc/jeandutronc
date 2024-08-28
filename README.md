df_families_per_code = pd.DataFrame()
for vnreli in file_list :
    count = 1
    print(f'starting code {vnreli}')
    df = pd.read_parquet(f'C:\\Users\\f25552\\OneDrive - BNP Paribas\\Documents\\Python\\IP_IP\\IP_IP_{vnreli}.parquet')
    G = nx.from_pandas_edgelist(df, source = 'psp_1',target='psp_2',create_using=nx.DiGraph)
    cycles = list(nx.simple_cycles(G))
    print(f'found {len(cycles)} loops')
    df_families = pd.DataFrame()
    for cycle in cycles:
        family=[]
        df_family = pd.DataFrame()
        ancestors = nx.ancestors(G,cycle[0])
        descendants = nx.descendants(G,cycle[0])
        family = [ancestors]+[descendants]
        list_family = [list(x) for x in family]
        df_family = pd.DataFrame([sum(list_family, [])], columns=[f"psp_{i}" for i in range(len(sum(list_family, [])))])
        df_families = pd.concat([df_families, df_family], ignore_index=True)
        print(f'{count} families added to the final df',end='\r')
        count+=1
    print('\n')
    df_families.insert(0,'Code',vnreli)
    df_families_per_code = pd.concat([df_families_per_code, df_families], ignore_index=True)
