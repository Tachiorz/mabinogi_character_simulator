from package import *

pack = mabi_pack("131_to_132.pack")

print pack.entries[1].name
buf = pack.read_for_entry(1)
print buf
