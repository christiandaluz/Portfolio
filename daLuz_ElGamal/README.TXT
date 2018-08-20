Completed 7 April 2016 for Applied Cryptography course
Final Grade for Course: A

This program demonstrates the ElGamal Encryption Scheme using preloaded values for agents "Alice" and "Bob."

"The Elgamal encryption scheme was proposed by Taher Elgamal in 1985. It is also often referred to as Elgamal 
encryption. It can be viewed as an extension of the DHKE protocol.... its security is also based on the 
intractability of the discrete logarithm problem and the Diffie-Hellman problem....
"We consider two parties, Alice and Bob. If Alice wants to send an encrypted message x to Bob, both parties
first perform a Diffie-Hellman key exchange to derive a shared key "kM". For this we assume that a large
prime "p" and a primitive element "alpha" have been generated. Now, the new idea is that Alice uses this key
as a multiplicative mask to encrypt x as y --> x * kM mod p." (Understanding Cryptography p. 226, by 
Christof Paar and Jan Pelzl)

a)  Bob chooses d, his private key value:     d = kprB such that 1 < kprB < p-1
b)  Bob computes beta, his public key value:  beta = kpubB ==> alpha^d mod p
    Bob sends beta (his public key) to Alice
c)  Alice chooses i, her private key value:   i = kprA such that 1 < kprA < p-1
d)  Alice computes kE, an ephemeral key for one message:  kE = kpubA ==> alpha^i mod p
    Alice sends kE to bob
    Alice and Bob compute kM, the joint key used for masking the plaintext
e)  Alice computes kM ==> beta^i mod p
f)  Bob computes kM ==> kE^d mod p
g)  Alice encrypts message x into y ==> x * kM mod p
    Alice sends encypted message y to Bob
h)  Bob decrypts message y into x ==> y * kM^-1 mod p

"The protocol consists of two phases, the classical DHKE (Steps a-f) which is followed by the message
encyrption and decryption (Steps g and h, respectively). Bob computes his private key d and public key
beta. This key pair does not change, i.e. it can be used for encrypting many message. Alice, however,
has to generate a new public-private key pair for the encryption of every message. Her private key
is denoted by i and her public key by kE. The latter is an ephemeral (existing only temporarily) key,
hence the index "E". The join key is denoted by kM because it is used for masking the plaintext.
"For the actual encryption, Alice simply multiplies the plaintext message x by the masking key kM.
On the receiving side, Bob reverses the encryption by multiplying with the inverse mask."
(Understanding Cryptography p. 227, by Christof Paar and Jan Pelzl)

For example:
Public values p and alpha are published: p = 467 and alpha = 2
Alice wishes to send Bob the message x: x = 33
a)  Bob chooses d = kprB = 105 (1 < 105 < 467-1)
b)  Bob computes beta = kpubB = alpha^d mod p = 2^105 mod 467 = 444
c)  Alice chooses i = kprA = 213 (1 < 213 < 467-1)
d)  Alice computes kE = kpubA = alpha^i mod p = 2^213 mod 467 = 29
e)  Alice computes kM = beta^i mod p = 444^213 mod 467 = 292
f)  Bob computes kM = kE^d mod p = 29^105 mod 467 = 292
g)  Alice encrypts message x; y = x*kM mod p = 33*292 mod 467 = 296
h)  Bob decrypts y; x = y*kmB^-1 mod p = 296*292^-1 mod 467 = 33
33 = 33
