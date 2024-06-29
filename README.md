for file_obj in file_list:
        for file_name in file_obj.files:
            if file_name.endswith('.xlsx') and not file_name.startswith('~'):
                #print(file_name)
                try:
                    result = run_with_timeout(process_file,args=(file_obj,file_name), timeout=3)
                    #print("Function returned:", result)
                except TimeoutException as e:
                    print("Timeout occurred:", e)
                except Exception as e:
                    print("Exception occurred during function execution:", e)
