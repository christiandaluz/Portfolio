Completed 7 April 2016 for Applied Cryptography course
Final Grade for Course: A

This program demonstrates the Diffie-Hellman Key Exchange using preloaded values for agents "Alice" and "Bob."

"The Diffie-Hellman Key Exchange (DHKE)... was the first asymmetric scheme published in open literature.... It 
provides a practical solution to the key distribution problem, i.e., it enables two parties to derive a common 
secret key by communicating over an insecure channel." (Understanding Cryptography, by Christof Paar and 
Jan Pelzl)

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
