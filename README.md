from docx import Document #pip install python-docx
from docx.opc.constants import RELATIONSHIP_TYPE as RT
import os
import re
import pandas as pd
import PyPDF2
from openpyxl import load_workbook
from openpyxl.packaging.relationship import Relationship
import xlwings as xw
from openpyxl.worksheet.worksheet import Worksheet
from concurrent.futures import ThreadPoolExecutor
import sys
import threading
from openpyxl.utils.exceptions import InvalidFileException
import pythoncom
import logging
from datetime import datetime
import warnings
import pickle    
warnings.filterwarnings("ignore")

# set folder address to scan
folder_path = r'F:\BusinessData\DATA_DEPARTMENT\01 CoE Data Governance\01 Data Quality'

# scan folder and find all pdf, excels and word documents

class FileObject:
    def __init__(self, root, dirs, files):
        self.root = root
        self.dirs = dirs
        self.files = files
        
    def __str__(self):
        return f"Root: {self.root} \nDirs: {self.dirs} \nFiles: {self.files}\n"
    
#file_objects = []
#valid_extensions = ('.pdf','.xlsx','.docx')
#
#for root, dirs, files in os.walk(folder_path):
#    filtered_files = [file for file in files if file.endswith(valid_extensions) and not file.startswith('~')]
#    if filtered_files:
#        file_objects.append(FileObject(root, dirs, filtered_files))


with open(r'C:\Users\f25552\OneDrive - BNP Paribas\Documents\test_link\file_objects.pkl','rb') as f:
    file_list = pickle.load(f)





    def extract_links_and_references_from_xlsx(file_path):
    links=[]
    external_references_cells=[]
    #print('started first function')
    try:
        try:
            wb = load_workbook(file_path,data_only=False,read_only=False)
            #print('file opened')
        except (openpyxl.utils.exceptions.InvalidFileException,zipfile.BadZipFile):
            
            #print('file skipped')
            pass
        external_ref_pattern = re.compile(r"\[([^\]]+)\]")
        
        for sheet_name in wb.sheetnames:
            print(f'{thread_name} - file {processed_excel_file_count} : sheetname:{sheet_name}')
            try:
                sheet = wb[sheet_name]
                #print(f'opened sheet {sheet_name}')
                for row in sheet.iter_rows(max_row=1000,max_col=25):
                    for cell in row:
                        if cell.hyperlink:
                            links.append(cell.hyperlink.target)
                        if cell.data_type=='f' and cell.value:
                            match = external_ref_pattern.search(cell.value)
                            if match:
                                match_text = match.group(0)
                                if match_text not in [item[2] for item in external_references_cells]:
                                    external_references_cells.append((sheet_name,cell.coordinate,match_text))
                
            except Exception as e:
                pass
        #print(f'finished processing first function')
    except Exception as e:
        pass
    return links, external_references_cells
        
        
def get_external_reference_value(file_path,reference_cells):
    external_references =[]
    app = xw.App(visible=False)
    #print(f'started second function')
    try:
        wb = app.books.open(file_path,read_only=True, password=None)
        #print('file opened')
        for sheet_name, cell_address,match_text in reference_cells:
            cell = wb.sheets[sheet_name].range(cell_address)
            try :
                if cell.formula:
                    external_references.append(cell.formula)
            except Exception as e:
                pass
            except PermissionError as pe:
                pass
        #print('finished processing second function')
        wb.close()
    except Exception as e:
        print(e)

    app.quit()
    return external_references


#function to print status line    
def print_statusline(msg: str):
    last_msg_length = len(getattr(print_statusline, 'last_msg', ''))
    print(' ' * last_msg_length, end='\r')
    print(msg, end='\r')
    sys.stdout.flush()  # Some say they needed this, I didn't.
    setattr(print_statusline, 'last_msg', msg) 

    
xlsx_with_links_and_references = []
excel_file_count=0
processed_excel_file_count = 0
max_path_length = 255


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
        print(f'thread {thread_name} finished executing')

      
with ThreadPoolExecutor(max_workers = max_workers) as executor:
    futures=[]
    for file_obj in file_list:
        
        for file_name in file_obj.files:
            if processed_excel_file_count ==50:
                break
            if file_name.endswith('.xlsx') and not file_name.startswith('~'):
                futures.append(executor.submit(process_file,file_obj,file_name))
    
    for future in futures:
        future.result()

xlsx_df = pd.DataFrame(xlsx_with_links_and_references)

xlsx_df['file_type'] = 'xlsx'
xlsx_df
max_workers = 4
counter_lock=threading.Lock()
