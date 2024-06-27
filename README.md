# scan folder and find all pdf, excels and word documents

class FileObject:
    def __init__(self, root, dirs, files):
        self.root = root
        self.dirs = dirs
        self.files = files
        
    def __str__(self):
        return f"Root: {self.root} \nDirs: {self.dirs} \nFiles: {self.files}\n"
    
file_objects = []
valid_extensions = ('.pdf','.xlsx','.docx')

for root, dirs, files in os.walk(folder_path):
    filtered_files = [file for file in files if file.endswith(valid_extensions) and not file.startswith('~')]
    if filtered_files:
        file_objects.append(FileObject(root, dirs, filtered_files))
