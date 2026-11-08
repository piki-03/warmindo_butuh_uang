import zipfile
import xml.etree.ElementTree as ET
import os

ET.register_namespace('', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')
NS = {'ns': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}

def build_inline_cell(col_letter, row_idx, style_idx, text):
    c = ET.Element('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c')
    c.set('r', f"{col_letter}{row_idx}")
    c.set('s', str(style_idx))
    if text is not None and text != "":
        c.set('t', 'inlineStr')
        is_tag = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}is')
        t_tag = ET.SubElement(is_tag, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t')
        t_tag.text = text
    return c

def build_formula_cell(col_letter, row_idx, style_idx, formula, val=""):
    c = ET.Element('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c')
    c.set('r', f"{col_letter}{row_idx}")
    c.set('s', str(style_idx))
    f_tag = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
    f_tag.text = formula
    v_tag = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
    v_tag.text = str(val) if val is not None else ""
    return c

def build_num_cell(col_letter, row_idx, style_idx, num_val):
    c = ET.Element('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c')
    c.set('r', f"{col_letter}{row_idx}")
    c.set('s', str(style_idx))
    v_tag = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
    v_tag.text = str(num_val)
    return c

print("Helper functions ready.")
