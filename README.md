def get_external_reference_value(file_path,reference_cells):
    external_references =[]
    app = xw.App(visible=False)
    try:
        wb = app.books.open(file_path,read_only=True,ignore_Read_only_command = True, password=None)
        
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

    app.quit()
    return external_references
