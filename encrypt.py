from __future__ import print_function

def dec_sub(c):
    if c > 59:
        if c > 90:
            res = c - 59
        else:
            res = c - 53
    else:
        res = c - 48
    return res

def decrypt(script):
    result = ""
    i = 0
    while i < len(script):
        dec = 0
        shift = 0
        while shift < 24:
            while ord(script[i]) < 32:
                i += 1
            dec |= dec_sub(ord(script[i])) << shift
            shift += 6
            i += 1
        dec ^= (dec >> 13) & 0x7F8
        shift = 16
        while shift > -8:
            d = dec >> shift & 0xFF
            shift -= 8
            result += chr(d)
    return result

def enc_sub(c):
    if c < 12:
        res = c + 48
    else:
        if c < 38:
            res = c + 53
        else:
            res = c + 59
    return res

def encrypt(script):
    result = ""
    i = 0
    while i < len(script):
        enc = 0
        shift = 16
        while shift > -8:
            if i < len(script): ch = ord(script[i])
            else: ch = 0
            enc |= ch << shift
            shift -= 8
            i += 1
        enc ^= (enc >> 13) & 0x7F8
        shift = 0
        while shift < 24:
            e = enc >> shift & 0x3F
            result += chr(enc_sub(e))
            shift += 6
    return result