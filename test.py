from encrypt import *
enc_script = "gTqIXBaE0BGNET7RzvWC286PRomPyfaQGoWPbZLO71rMePqQ2PaRC8r;M4b;Bm2Ql8a2zVqMZnaQERaPk;6Q:5LNX1KMycE3P5LNakKOi038BK3Ar8Y2olqMM5rPpFXFT4IF8dE3"
dec_script = decrypt(enc_script)
print dec_script
print enc_script
enc_script2 = encrypt(dec_script)
print enc_script2
print enc_script == enc_script2

script = """SetBase http://localhost/cs/serve.x/
background paperback
Version 1.04
Bgcolor F6EEC7

"""
print encrypt(script)
