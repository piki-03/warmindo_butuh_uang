import zipfile
import xml.etree.ElementTree as ET

with zipfile.ZipFile('UAT_template.xlsx', 'r') as z:
    for i in [1, 2]:
        sf = f'xl/worksheets/sheet{i}.xml'
        print(f"\n==================== SHEET {i} ({sf}) ====================")
        sheet_tree = ET.fromstring(z.read(sf))
        rows = sheet_tree.findall('.//{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
        for r in rows[:15]:
            row_data = []
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                is_tag = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}is')
                v_tag = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
                if is_tag is not None:
                    t_tag = is_tag.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t')
                    val = t_tag.text if t_tag is not None else ''
                elif v_tag is not None:
                    val = v_tag.text
                else:
                    val = ''
                cell_ref = c.get('r')
                if val:
                    row_data.append(f"{cell_ref}: {val}")
            if row_data:
                print(f"Row {r.get('r')}: {' | '.join(row_data)}")
