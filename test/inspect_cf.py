import zipfile
import xml.etree.ElementTree as ET

with zipfile.ZipFile('UAT_template.xlsx', 'r') as z:
    for i in [2, 3, 5]:
        sf = f'xl/worksheets/sheet{i}.xml'
        tree = ET.fromstring(z.read(sf))
        cfs = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}conditionalFormatting')
        for cf in cfs:
            print(f"Sheet {i} conditionalFormatting sqref={cf.get('sqref')}: {ET.tostring(cf, encoding='unicode')}")
