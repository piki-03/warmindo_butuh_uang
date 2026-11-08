import zipfile
import xml.etree.ElementTree as ET

with zipfile.ZipFile('UAT_template.xlsx', 'r') as z:
    for i in range(1, 6):
        sf = f'xl/worksheets/sheet{i}.xml'
        tree = ET.fromstring(z.read(sf))
        dvs = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidations/{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidation')
        if dvs:
            print(f"\nSheet {i} Data Validations:")
            for dv in dvs:
                formula = dv.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}formula1')
                f_txt = formula.text if formula is not None else ''
                print(f"  sqref: {dv.get('sqref')}, type: {dv.get('type')}, formula1: {f_txt}")
