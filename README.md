import os
import threading
import pythoncom
import pandas as pd
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor
import concurrent.futures

# Initialize variables and locks
excel_file_count = 0
processed_excel_file_count = 0
counter_lock = threading.Lock()
processed_list = []
xlsx_with_links_and_references = []
max_path_length = 255  # Set your max path length if necessary

# Placeholder functions
def extract_links_and_references_from_xlsx(file_path):
    # Placeholder for actual function to extract links and references
    return [], []

def get_external_reference_value(file_path, ref_links_coord):
    # Placeholder for actual function to get external reference values
    return []

# Timeout wrapper function
def run_with_timeout(func, args=(), kwargs={}, timeout=10):
    result = [TimeoutException(f"Timeout while processing {args[1]}")]

    def wrapper():
        try:
            result[0] = func(*args, **kwargs)
        except Exception as e:
            result[0] = e

    thread = threading.Thread(target=wrapper)
    thread.start()
    thread.join(timeout)
    if thread.is_alive():
        return TimeoutException(f"Timeout while processing {args[1]}")
    else:
        return result[0]

# Modified process_file function
def process_file(file_obj, file_name):
    global processed_excel_file_count
    with counter_lock:
        processed_excel_file_count += 1

    thread_name = threading.current_thread().name
    start_time = datetime.now().strftime('%H:%M:%S.%f')
    print(f'{start_time} - {thread_name} starting for {processed_excel_file_count} - {os.path.join(file_obj.root, file_name)}')

    def file_processing_logic():
        pythoncom.CoInitialize()
        try:
            file_path = os.path.join(file_obj.root, file_name)
            if len(file_path) > max_path_length:
                pass
            else:
                xlsx_links, ref_links_coord = extract_links_and_references_from_xlsx(file_path)
                if ref_links_coord:
                    external_references = get_external_reference_value(file_path, ref_links_coord)
                else:
                    external_references = []
                if xlsx_links or external_references:
                    xlsx_with_links_and_references.append({
                        'file_path': file_path,
                        'file_name': file_name,
                        'hyperlinks': xlsx_links,
                        'references': external_references
                    })
        finally:
            pythoncom.CoUninitialize()
            return "Processed"

    result = run_with_timeout(file_processing_logic, args=(file_obj, file_name))
    if isinstance(result, TimeoutException):
        print(f"Error: {result}")
    else:
        processed_list.append(os.path.join(file_obj.root, file_name))
        print(f'{thread_name} finished executing')

# Sample file list (replace this with actual file objects)
file_list = []  # Populate this list with actual file objects

# Count Excel files
for file_obj in file_list:
    for file in file_obj.files:
        if file.endswith('.xlsx') and not file.startswith('~'):
            excel_file_count += 1
print(f"Excel file count: {excel_file_count}")

# Process files with ThreadPoolExecutor
max_workers = 4  # Adjust as needed
with ThreadPoolExecutor(max_workers=max_workers) as executor:
    futures = []
    for file_obj in file_list:
        for file_name in file_obj.files:
            if file_name.endswith('.xlsx') and not file_name.startswith('~'):
                futures.append(executor.submit(process_file, file_obj, file_name))
    for future in concurrent.futures.as_completed(futures):
        try:
            future.result()
        except Exception as e:
            print(f"Exception occurred during processing: {e}")

print("Processing complete")
