for file_obj in file_objects:
    for file in file_obj.files:
        if file.endswith('.xlsx') and not file.startswith('~'):
            excel_file_count +=1
print(f"excel file count : {excel_file_count}")
 

def process_file(file_obj,file_name):
    global processed_excel_file_count
    try:
        pythoncom.CoInitialize()
        file_path = os.path.join(file_obj.root, file_name)
        
        if len(file_path) > max_path_length:
            return
        else:
            xlsx_links, ref_links_coord = extract_links_and_references_from_xlsx(file_path)
            if ref_links_coord:
                external_references = get_external_reference_value(file_path,ref_links_coord)
            else:
                external_references=[]
            if xlsx_links or external_references:
                xlsx_with_links_and_references.append({'file_path' : file_path,'file_name':file_name,'hyperlinks':xlsx_links,'references':external_references})
        with counter_lock:
            processed_excel_file_count +=1   
            #print(processed_excel_file_count)
            print_statusline(f'processed {processed_excel_file_count}')
    except Exception as e:
        print(e)
    finally:
        pythoncom.CoUninitialize()
    
with ThreadPoolExecutor(max_workers = max_workers) as executor:
    futures=[]
    for file_obj in file_objects:
        for file_name in file_obj.files:
            if file_name.endswith('.xlsx') and not file_name.startswith('~'):
                futures.append(executor.submit(process_file,file_obj,file_name))
    
    for future in futures:
        future.result()

xlsx_df = pd.DataFrame(xlsx_with_links_and_references)

xlsx_df['file_type'] = 'xlsx'
xlsx_df
