# -*- coding: utf-8 -*-
import os, struct, zlib
import MT, material
#this is shallow port of https://github.com/darknesstm/MabinogiPackageTool/


class pack_entry(tuple):
    _fields = ('package',
               'index',
               'name',
               'seed',
               'offset',
               'compress_size',
               'decompress_size',
               'is_compressed',
               'name',
               'filetime',
               )


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

    def __init__(self, filename=None):
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
            struct.unpack("8sLLQQ480s", f.read(480+32))
        if magic != "PACK\x02\x01\0\0":
            print "File not supported"
            return
        self.listCount, self.headerSize, self.blankSize, self.dataSectionSize, _ =\
            struct.unpack("LLLL16s", f.read(32))
        self.entries = list()
        off = f.tell() + self.headerSize
        for i in range(self.listCount):
            e = pack_entry()
            e.package = self
            e.index = i
            l = ord(f.read(1))
            if l < 4:
                e.name = f.read((l+1)*0x10-1)
            elif l == 4:
                e.name = f.read(0x60-1)
            else:
                l = struct.unpack("l", f.read(4))[0]
                e.name = f.read(l)
            e.name = e.name.strip('\0')
            e.seed, _, e.offset, e.compress_size, e.decompress_size, e.is_compressed =\
                struct.unpack("LLLLLL", f.read(24))
            e.offset += off
            e.filetime = struct.unpack("QQQQQ",f.read(40))
            self.entries += [e]

    def _decrypt(self, buf, seed):
        rseed = (seed << 7) ^ 0xA9C36DE1
        MT.sgenrand(rseed)
        buf = bytearray(buf)
        for i in range(len(buf)):
            buf[i] ^= MT.genrand() & 0xFF
        return bytes(buf)

    def read_for_entry(self, index):
        self._f.seek(self.entries[index].offset)
        buf = self._f.read(self.entries[index].compress_size)
        buf = self._decrypt(buf, self.entries[index].seed)
        buf = zlib.decompress(buf)
        return buf


class mabi_assets:
    tree = None
    types = None
    key = (0xEE, 0xA6, 0x60, 0x64, 0x47, 0x37, 0xFC)

    def __init__(self, path=None):
        self.tree = dict()
        self.types = dict()
        self.types['.frm'] = dict()
        self.types['.pmg'] = dict()
        self.types['.dds'] = dict()
        self.types['.ani'] = dict()
        if path is None: return
        try:
            files = os.listdir(path)
        except WindowsError:
            print "Can't open ..\\package directory\n" \
                  "Make sure this character simulator located inside mabinogi folder"
            return
        for f in files:
            if f[-5:] == '.pack':
                p = mabi_pack(path+f)
                self._add_enties(p)
        material.load_materials(self)

    def _add_enties(self, pack):
        for e in pack.entries:
            cur = self.tree
            for p in e.name.split('\\'):
                p = p.lower()
                if p.find('.') != -1:
                    cur[p] = e
                    t = p[-4:]
                    if t in self.types: self.types[t][p] = e
                    break
                if p not in cur:
                    cur[p] = dict()
                cur = cur[p]

    def _encrypt(self, buf):
        buf = bytearray(buf)
        for i in range(len(buf)):
            buf[i] ^= (i ^ (self.key[(i ^ 5) % 7] + 1)) & 0xFF
        return bytes(buf)

    def get_file(self, f):
        d = None
        f = f.lower()
        t = f[-4:]
        if t in self.types and f in self.types[t]: d = self.types[t][f]
        elif f[-5:] == '.desc':
            # this is ugly
            if f[:-9].lower() in material.materials:
                return material.materials[f[:-9]].toString()
        else:
            cur = self.tree
            for p in f.split('\\'):
                if p.find('.') != -1 and p in cur:
                    return cur[p].package.read_for_entry(cur[p].index)
                if p in cur: cur = cur[p]
        if d is None: return None
        return d.package.read_for_entry(d.index)

    def get_x_file(self, f):
        buf = self.get_file(f)
        if buf is None: return None
        l = len(buf)
        buf = zlib.compress(buf)[2:-4]
        return self._encrypt(struct.pack('I',l) + buf)
