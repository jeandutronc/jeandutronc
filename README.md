xlsx_with_links_and_references = []
excel_file_count=0
processed_excel_file_count = 0

def extract_links_and_referencesfrom_xlsx(file_path):
    links=[]
    external_references_cells=[]
    wb = load_workbook(file_path,data_only=False,read_only=True)
    try:
        external_ref_pattern = re.compile(r"\[([^\]]+)\]")
        for sheet_name in wb.sheetnames:
            sheet = wb[sheet_name]
            if isinstance(sheet, Worksheet):
                for row in sheet.iter_rows():
                    for cell in row:
                        if cell.hyperlink:
                            links.append(cell.hyperlink.target)
                        if cell.data_type=='f' and cell.value:
                            match = external_ref_pattern.search(cell.value)
                            if match:
                                match_text = match.group(0)
                                print(match_text)
                                if match_text not in [item[2] for item in external_references_cells]:
                                    external_references_cells.append((sheet_name,cell.coordinate,match_text))
    except Exception as e:
        pass
    except PermissionError as pe:
        pass
    return links,external_references_cells
        
        
def get_external_reference_value(file_path,reference_cells):
    external_references =[]
    app = xw.App(visible=False)
    try:
        wb = app.books.open(file_path)
        
        for sheet_name, cell_address,match_text in reference_cells:
            cell = wb.sheets[sheet_name].range(cell_address)
            try :
                if cell.formula:
                    external_references.append(cell.formula)
            except Exception as e:
                pass
            except PermissionError as pe:
                pass
        wb.close()
    except Exception as e:
        pass
    except PermissionError as pe:
        pass

    app.quit()
    return external_references
    
def process_folder_for_excel_files(folder_path):    
    for file_obj in file_objects:
        for file_name in file_obj.files:
            if file_name.endswith('.xlsx') and not file_name.startswith('~'):
                file_path= os.path.join(file_obj.root, file_name)
                xlsx_links, ref_links_coord = extract_links_and_referencesfrom_xlsx(file_path)
                external_references = get_external_reference_value(file_path,ref_links_coord)
                if xlsx_links or external_references:
                    xlsx_with_links_and_references.append({'file_path' : file_path,'file_name':file_name,'hyperlinks':xlsx_links,'references':external_references})
                processed_excel_file_count +=1    
                print(f"\rprocessed: {processed_excel_file_count} / {excel_file_count}",end='',flush=True)  
                return xlsx_with_links_and_references


for file_obj in file_objects:
    for file in file_obj.files:
        if file.endswith('.xlsx') and not file.startswith('~'):
            excel_file_count +=1
print(f"excel file count : {excel_file_count}")            
            
            
xlsx_with_links_and_references = process_folder_for_excel_files(folder_path)        
            
xlsx_df = pd.DataFrame(xlsx_with_links_and_references)
xlsx_df['file_type'] = 'xlsx'
xlsx_df
