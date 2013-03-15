import zlib
from package import *

a = mabi_assets()
f = open('giant_male_c4_2011foxmonster_bss.pmg.z','rb')
buf = f.read()
f.close()

buf = a._encrypt(buf)
buf = zlib.decompress(buf[4:],-15)

f = open('giant_male_c4_2011foxmonster_bss.pmg','wb+')
f.write(buf)
f.close()
