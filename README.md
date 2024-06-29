for file_obj in file_list:
    for file in file_obj.files:
        if file.endswith('.xlsx') and not file.startswith('~'):
            excel_file_count +=1
print(f"excel file count : {excel_file_count}")
 

def process_file(file_obj,file_name):
    global processed_excel_file_count
    with counter_lock:
        processed_excel_file_count +=1   
        
    thread_name = threading.current_thread().name
    start_time = datetime.now().strftime('%H:%M:%S.%f')
    print(f'{start_time} - {thread_name} starting for {processed_excel_file_count} -  {os.path.join(file_obj.root, file_name)}')
    try:
        pythoncom.CoInitialize()
        file_path = os.path.join(file_obj.root, file_name)
        
        if len(file_path) > max_path_length:
            pass
        
        else:
            #print(f'{thread_name} - length ok')
            xlsx_links, ref_links_coord = extract_links_and_references_from_xlsx(file_path)
            #print(f'{thread_name} - first function done')
            if ref_links_coord:
                external_references = get_external_reference_value(file_path,ref_links_coord)
            else:
                external_references=[]
            #print(f'{thread_name} - second function done')
            if xlsx_links or external_references:
                xlsx_with_links_and_references.append({'file_path' : file_path,'file_name':file_name,'hyperlinks':xlsx_links,'references':external_references})
            #print(f'{thread_name} - appended result')
            #print(processed_excel_file_count)
            #print_statusline(f'processed {processed_excel_file_count}')
    except Exception as e:
        print(e)
    finally:
        pythoncom.CoUninitialize()
        processed_list.append(os.path.join(file_obj.root, file_name))
        print(f'thread {thread_name} finished executing')

        
        
        
def run_with_timeout(executor,func,timeout, file_obj, file_name, timed_out_files):
    future = executor.submit(func,file_obj, file_name)
    try:
        result = future.result(timeout=timeout)
        return result
    except concurrent.futures.TimeoutError:
        future.cancel()
        thread_name = threading.current_thread().name
        print(f"Task {thread_name} with {file_name} exceeded timeout of {timeout} seconds")
        
        filepath = os.path.join(file_obj.root, file_name)
        timed_out_files.append(filepath)
        return None
    except Exception as e:
        print(f"Exception occurred: {e}")
        return None
      
with ThreadPoolExecutor(max_workers = max_workers) as executor:
    futures=[]
    for file_obj in file_list:
        
        for file_name in file_obj.files:
            if file_name.endswith('.xlsx') and not file_name.startswith('~'):
                futures.append(
                    executor.submit(run_with_timeout,executor, process_file, timeout, file_obj, file_name,timed_out_files)
                )
    
    for future in concurrent.futures.as_completed(futures):
        try:
            future.result()
        except Exception as e:
            print(f"Exception occurred during processing:{e}")
            
print("Processing complete")
