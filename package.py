# -*- coding: utf-8 -*-
import struct, zlib
import MT
#this is shallow port of https://github.com/darknesstm/MabinogiPackageTool/

class pack_entry:
    name = ""
    seed = 0
    offset = 0
    compress_size = 0
    decompress_size = 0
    is_compressed = False
    filetime = None
    def __init__(self):
        self.filetime = [0] * 5


class mabi_pack:
    filename = None
    _f = None
    #header
    checksum = 0
    seed = 0
    filetime1 = None
    filetime2 = None
    path = None
    #list header
    listCount = 0
    headerSize = 0
    blankSize = 0
    dataSectionSize = 0
    entries = None

    def __init__(self, filename):
        self.filename = filename
        if filename is not None:
            self.open(filename)

    def __del__(self):
        if self._f is not None: self._f.close()

    def open(self, filename):
        f = open(filename,"rb")
        self._f = f
        #read header
        magic, self.seed, self.checksum, self.filetime1, self.filetime2, self.path =\
        struct.unpack("8sLLQQ480s",f.read(480+32))
        if magic != "PACK\x02\x01\0\0":
            print "File not supported"
            return
        self.listCount, self.headerSize, self.blankSize, self.dataSectionSize, _ =\
        struct.unpack("LLLL16s",f.read(32))
        self.entries = list()
        off = f.tell() + self.headerSize
        for _ in range(self.listCount):
            e = pack_entry()
            l = ord(f.read(1))
            if l < 4:
                e.name = f.read((l+1)*0x10-1)
            elif l == 4:
                e.name = f.read(0x60-1)
            else:
                l = struct.unpack("l", f.read(4))[0]
                e.name = f.read(l-5)
            e.seed, _, e.offset, e.compress_size, e.decompress_size, e.is_compressed =\
                struct.unpack("LLLLLL", f.read(24))
            e.offset += off
            e.filetime = struct.unpack("QQQQQ",f.read(40))
            self.entries += [e]

    def _decrypt(self, buf, seed):
        rseed = (seed << 7) ^ 0xA9C36DE1
        MT.sgenrand(rseed)
        result = bytes()
        for b in buf:
            c = chr(ord(b) ^ MT.genrand() & 0xFF)
            result += c
        return result

    def read_for_entry(self, index):
        self._f.seek(self.entries[index].offset)
        buf = self._f.read(self.entries[index].compress_size)
        buf = self._decrypt(buf, self.entries[index].seed)
        buf = zlib.decompress(buf)
        return buf
