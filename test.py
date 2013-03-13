from encrypt import *
enc_script = "gTqIXBaE0BGNET7RzvWC3k6PUxKMA0rP;8q;R8r;pLbQTZb;l8a2zVqMZnaQERaPk;6Q:5LNX1KMpMZ2t3bQMpqPsyGAWj0BL1qNGk6PqQ48fRIFmikB"
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
