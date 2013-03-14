import zlib
from package import *

a = mabi_assets()
f = open('male_c4_zoro01_c.dds.desc.z','rb')
buf = f.read()
f.close()

buf = a._encrypt(buf)
buf = zlib.decompress(buf[4:],-15)

f = open('male_c4_zoro01_c.dds.desc','wb+')
f.write(buf)
f.close()
