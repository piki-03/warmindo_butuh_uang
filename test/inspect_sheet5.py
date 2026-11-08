import zipfile
import xml.etree.ElementTree as ET

with zipfile.ZipFile('UAT_template.xlsx', 'r') as z:
    sf = 'xl/worksheets/sheet5.xml'
    tree = ET.fromstring(z.read(sf))
    sheet_data = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData')
    for r in sheet_data.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row'):
        row_str = f"Row {r.get('r')}: "
        for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
            cell_ref = c.get('r')
            f_tag = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
            is_tag = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}is')
            v_tag = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
            txt = ''
            if is_tag is not None:
                t = is_tag.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t')
                if t is not None: txt = t.text or ''
            elif v_tag is not None:
                txt = v_tag.text or ''
            formula = f" [formula: {f_tag.text}]" if f_tag is not None else ""
            row_str += f"{cell_ref}='{txt}'{formula} | "
        print(row_str)
