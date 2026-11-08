import zipfile
import xml.etree.ElementTree as ET

with zipfile.ZipFile('UAT_template.xlsx', 'r') as z:
    for i in range(1, 6):
        sf = f'xl/worksheets/sheet{i}.xml'
        tree = ET.fromstring(z.read(sf))
        print(f"Sheet {i} tags: {[child.tag.split('}')[-1] for child in tree]}")
        cols = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}cols')
        if cols is not None:
            col_list = [(c.get('min'), c.get('max'), c.get('width')) for c in cols.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}col')]
            print(f"Sheet {i} cols:", col_list)
        autofilter = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}autoFilter')
        if autofilter is not None:
            print(f"Sheet {i} autoFilter:", autofilter.attrib)
