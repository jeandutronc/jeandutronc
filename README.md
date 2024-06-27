

def extract_links_and_references_from_xlsx(file_path):
    links=[]
    external_references_cells=[]
    try:
        wb = load_workbook(file_path,data_only=False,read_only=False)
        external_ref_pattern = re.compile(r"\[([^\]]+)\]")
        for sheet_name in wb.sheetnames:
            try:
                sheet = wb[sheet_name]
                for row in sheet.iter_rows():
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
    except Exception as e:
        pass
    return links, external_references_cells
