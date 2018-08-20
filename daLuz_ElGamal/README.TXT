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

Bob chooses d = k

Bob computes beta = alpha^d mod p = 2^105 mod 467 = 444
Alice computes ke = alpha^i mod p = 2^213 mod 467 = 29
Alice computes her km = beta^i mod p = 444^213 mod 467 = 292
Alice encrypts x; y = x*kmA mod p = 33*292 mod 467 = 296
Bob computers his km = ke^d mod p = 29^105 mod 467 = 292
Bob decrypts y: x = y*kmB^-1 mod p = 296*292^-1 mod 467 = 33
33 = 33


A large prime "p" and an integer "alpha" such that 1 < alpha < p-1 are chosen and then published. 
The two participating agents, "Alice" and "Bob" choose their own private key values "a" and "b" such 
that 1 < a, b < p-1.

Alice computes A = kpubA = alpha^a ==> alpha^a mod p 
Bob computes   B = kpubB = alpha^b ==> alpha^b mod p 

Alice and Bob then exchange their public keys and compute, respectively, kpubB^a mod p and kpubA^b mod p.
Effectively: 
Alice computes B^alpha ==> (alpha^b)^a ==> alpha^ab mod p
Bob computes   A^alpha ==> (alpha^a)^b ==> alpha^ab mod p

The key can now be used to establish a secure communication between Alice and Bob.

