total_runtime_start = datetime.now()
run = 1

parquet_file = pq.ParquetFile(path+dataset_filename)
chunk_size = parquet_file.metadata.row_group(0).num_rows
loops = math.ceil(parquet_file.metadata.num_rows/chunk_size)


#open file in loop and add data to IP if necessary
#for main_dataframe in pd.read_parquet(path+dataset_filename, chunksize = chunk_size):
    
for i in range(0,loops-1)  :
    main_dataframe = parquet_file.read_row_group(i).to_pandas()
    
    loop_start = datetime.now()
    if segment == 'IP':
        ip_df = main_dataframe[~main_dataframe['rel_psp'].isna()]
        ip_df = ip_df.drop(columns=['lastrecertificationdate','nextrecertificationdate','countryofactivity','sectorofactivity','kycfile_financialsecuritysegmen','party_financialsecuritysegment','party_risklevel','party_undersanction'])
        to_add_df = main_dataframe[['psp','lastrecertificationdate','nextrecertificationdate','countryofactivity','sectorofactivity','kycfile_financialsecuritysegmen','party_financialsecuritysegment','party_risklevel','party_undersanction']]
        main_dataframe = pd.merge(ip_df,to_add_df,left_on ='psp', right_on = 'rel_psp',how = 'inner')
    
    #filter on correct person type
    main_dataframe = main_dataframe[main_dataframe['kl_type_person']==type_person]
    main_dataframe = main_dataframe.reset_index()
    main_dataframe = main_dataframe.drop(columns=['index'])
    
    print(f"loop {run} of {loops} for {segment} contains {len(main_dataframe)} rows")
    
    #add postcode formats
    main_dataframe = pd.merge(main_dataframe,grouped_post_codes,left_on='kl_country',right_on='ISO3166-1',how='left')
    
    #create birth date field based on birth year, month and day fields
    main_dataframe['kl_birth_date'] = main_dataframe['kl_birth_date_year']+r'/'+main_dataframe['kl_birth_date_month']+r'/'+main_dataframe['kl_birth_date_day']
    
    
    result_psp_level = main_dataframe['psp']  # create new dataframe where columns are appended for each control
    result_psp_level = pd.DataFrame(result_psp_level)
     
    start_time_full = datetime.now() #start of control run on each loop
    ctrl_nb = 1
    
    #loop where controls are applied
    for index, row in framework_list.sort_values('Fields').iterrows():
        
        start_time = datetime.now()
        
        field = row['Fields']
        control = row['to_run_control']
        input_format = row['Format']
        
        work_framework = framework_dataframe[framework_dataframe['Fields'] ==field]
        output_field_name = control+'$'+field
        result_psp_level[output_field_name] =   fn_run_all_functions(
                                                field_name = field,
                                                input_df = main_dataframe, 
                                                to_run_framework = work_framework,
                                                control_name=control
                                                )
        

        end_time = datetime.now()
        
        print(f"\r{str(ctrl_nb)} / {str(len(framework_list))} done in {round((end_time-start_time_full).total_seconds(),2)}s",end="",flush=True)
        
        ctrl_nb = ctrl_nb+1
        
    #append results of current loop to total results    
    result_psp_level_final = result_psp_level_final.append(result_psp_level)
    
    print("\r"+" "*50+"\r",end='',flush=True)
    loop_end = datetime.now()
    print(f"loop {run} done in {round((loop_end-loop_start).total_seconds(),2)}s")
    print("\r",end='')
    run = run+1
    
total_runtime_end = datetime.now()
print(f"ran {loops} loops in {round((total_runtime_end-total_runtime_start).total_seconds(),2)}s")
