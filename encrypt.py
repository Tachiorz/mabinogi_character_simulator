__author__ = 'Roman'

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
        dec = (dec >> 13) & 0x7F8 ^ dec
        shift = 16
        while shift > -8:
            d = dec >> shift & 0xFF
            shift -= 8
            result += chr(d)
    return result
