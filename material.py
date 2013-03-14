from StringIO import StringIO
import xml.etree.ElementTree as ET
import time
import package

materials = dict()

class material(tuple):
    _fields = (
        'CastShadow',
        'EnableCartoonRender',
        'GlossTexture',
        'BackFaceCulling',
        'EnableZCompare',
        'EnableZWrite',
        'EnableAlphaTest',
        'EnableAlphaBlend',
        'ColorOp_0',
        'ColorArg1_0',
        'ColorArg2_0',
        'AlphaOp_0',
        'AlphaArg1_0',
        'AlphaArg2_0',
        'UVGeneration_0',
        'ColorOp_1',
        'ColorArg1_1',
        'ColorArg2_1',
        'AlphaOp_1',
        'AlphaArg1_1',
        'AlphaArg2_1',
        'UVGeneration_1',
    )
    def toString(self):
        result = ""
        for i in self._fields:
            result += str.format("{0} {1}\n", i, self.__getattribute__(i))
        return result

def strbool_toint(s):
    if s.strip(' ').lower() == 'false': return 0
    else: return 1

def load_materials(assets):
    global materials
    print "Parsing materials"
    t1 = time.clock()
    mat_list = assets.tree['material']['_define']['material']['character']
    for n,mat in mat_list.items():
        if n[-4:] != '.xml': continue
        txt = mat.package.read_for_entry(mat.index)
        if txt[0] == chr(255): xml = unicode(txt,'utf-16-le', errors='replace')
        else: xml = unicode(txt,'ascii', errors='replace')
        xml = xml.encode('utf-8')
        xml = str.replace(xml,'"','" ')
        xml = str.replace(xml,'&','')
        xml = ET.fromstring(xml)
        for i in xml[0]:
            name = i.attrib['Name'].strip(' ').lower()
            m = material()
            m.CastShadow = strbool_toint(xml.attrib['CastShadow'])
            m.EnableCartoonRender = strbool_toint(xml.attrib['EnableOutline'])
            m.GlossTexture = xml.attrib['GlossTexture'].strip(' ')
            m.BackFaceCulling = strbool_toint(xml.attrib['BackFaceCullWhenAlpha'])
            m.EnableZCompare = 1
            m.EnableZWrite = 1
            m.EnableAlphaTest = 1
            m.EnableAlphaBlend = 1
            m.ColorOp_0 = 'addsigned'
            m.ColorArg1_0 = 'texture'
            m.ColorArg2_0 ='diffuse'
            m.AlphaOp_0 ='selectfirst'
            m.AlphaArg1_0 ='texture'
            m.AlphaArg2_0 ='diffuse'
            m.UVGeneration_0 ='vertex'
            m.ColorOp_1 ='modulate4x'
            m.ColorArg1_1 ='texture'
            m.ColorArg2_1 ='current'
            m.AlphaOp_1 ='selectfirst'
            m.AlphaArg1_1 ='current'
            m.AlphaArg2_1 ='diffuse'
            m.UVGeneration_1 ='gloss'
            materials[name] = m
    t2 = time.clock()
    print "Done in", t2 - t1, "sec"