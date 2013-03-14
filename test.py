from encrypt import *
enc_script = "NdqNjQbP48KP;lJNOv5BL4rPT33Ac:nQR4b;MAmN"
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
