
for file_obj in file_objects:
    for file_name in file_obj.files:
        if file_name.endswith('.xlsx') and not file_name.startswith('~'):
            file_path= os.path.join(file_obj.root, file_name)
            if len(file_path) > max_path_length:
                continue
            else:
                print_statusline(f'processing {processed_excel_file_count+1} : {file_path}')
                xlsx_links, ref_links_coord = extract_links_and_references_from_xlsx(file_path)
                external_references = get_external_reference_value(file_path,ref_links_coord)
                if xlsx_links or external_references:
                    xlsx_with_links_and_references.append({'file_path' : file_path,'file_name':file_name,'hyperlinks':xlsx_links,'references':external_references})
            processed_excel_file_count +=1   
