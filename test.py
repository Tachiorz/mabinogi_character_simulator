from encrypt import *
enc_script = "gNKEPQKH2A2O1QqPU428NdqNjQbP48KP;lJNGu5Bl23A8laN6kKPxTrQmnZQq2rQbv6QU428U428S2HB:FHNV;aCU428wSKAiMnMW;aCU4286GXBVEnMX;aCU428kY38s73CXj3A062BU438"
dec_script = decrypt(enc_script)
print dec_script
print enc_script
enc_script2 = encrypt(dec_script)
print enc_script2
print enc_script == enc_script2

script = """giant_male_c4_zoro01_s10.pmg"""
print encrypt(script)
