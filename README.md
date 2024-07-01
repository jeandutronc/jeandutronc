with ThreadPoolExecutor(max_workers = max_workers) as executor:
    futures=[]
    for file_obj in file_list:
        
         
        for file_name in file_obj.files:
            if file_name.endswith('.xlsx') and not file_name.startswith('~'):
                #partial = partial(func_timeout,40,process_file,arfile_obj,file_name))
                future = executor.submit(func_timeout,40,process_file,args=(file_obj,file_name))#,timeout=150)
                futures.append(future)
                
    for future in concurrent.futures.as_completed(futures):
        try:
            result = future.result()
        except FunctionTimedOut as e:
            print(f'{file_name} - time out after 40 seconds')
        except Exception as e:
            print('Exception',e)
