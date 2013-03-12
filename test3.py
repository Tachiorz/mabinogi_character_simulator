import zlib
from package import *

a = mabi_assets()
f = open('hair03.dds.desc.z','rb')
buf = f.read()
f.close()

buf = a._encrypt(buf)
buf = zlib.decompress(buf[4:],-15)

f = open('hair03.dds.desc','wb+')
f.write(buf)
f.close()
