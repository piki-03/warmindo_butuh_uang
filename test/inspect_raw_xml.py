import zipfile
import xml.etree.ElementTree as ET

with zipfile.ZipFile('UAT_template.xlsx', 'r') as z:
    for i in range(1, 6):
        sf = f'xl/worksheets/sheet{i}.xml'
        tree = ET.fromstring(z.read(sf))
        print(f"\n==================== SHEET {i} ({sf}) ====================")
        # Check sheetViews, cols, sheetFormatPr
        for child in tree:
            tag = child.tag.split('}')[-1]
            if tag != 'sheetData':
                print(f"Tag: {tag}, attrib: {child.attrib}")
        sheet_data = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData')
        rows = sheet_data.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
        print(f"Rows count: {len(rows)}")
        # Print first 5 rows raw XML
        for r in rows[:6]:
            print(ET.tostring(r, encoding='unicode'))
