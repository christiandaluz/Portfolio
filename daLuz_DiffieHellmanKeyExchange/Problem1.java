/*
CSC381: Applied Cryptograph
Discrete Logarithmic Problems Homework
Prof. Dr. Kees Leune
Spring 2016
1. Write a program that computes the two public keys, and the common
key for the DHKE scheme with the parameters p = 467; alpha = 2, and
(a) a = 3; b = 5
(b) a = 400; b = 134
(c) a = 288; b = 57
In all cases, perform the necessary computation of the common key for
Alice and Bob.
 */
import java.math.BigInteger;
public class Problem1 {
	public static void main(String[] args) {
		//declare and initialize variables
		BigInteger p = new BigInteger("467");
		BigInteger alpha = new BigInteger("2");
		
		BigInteger a, b;
		
		a = new BigInteger("3");
		b = new BigInteger("5");
		
		//compute the results for the first set of numbers
		computeResults(a, b, alpha, p);
		
		//compute the results for the next set of numbers
		a = BigInteger.valueOf(400);
		b = BigInteger.valueOf(134);
		computeResults(a, b, alpha, p);
		
		//compute the results for the next set of numbers
		a = BigInteger.valueOf(288);
		b = BigInteger.valueOf(57);
		computeResults(a, b, alpha, p);
	}
	
	//Conducts the Diffie-Hellman Key Exchange protocol
	public static BigInteger DHKE(BigInteger a, BigInteger alpha, BigInteger p) {
		return alpha.modPow(a, p);
	}

	//Creates the session key
	public static BigInteger getSessionKey(BigInteger kpub, BigInteger a, BigInteger p) {
		return kpub.modPow(a, p);
	}
	
	//Computes and prints results of DHKE and session key for Alice and Bob
	public static void computeResults(BigInteger a, BigInteger b, BigInteger alpha, BigInteger p) {
		//Alice's DHKE and public key
		System.out.print("Alice's public key = alpha^a mod p = ");
		System.out.print(alpha + "^" + a + " mod " + p + " = ");
		BigInteger kpubA = DHKE(a, alpha, p);
		System.out.println(kpubA);
		
		//Bob's DHKE and public key
		System.out.print("Bob's public key = alpha^b mod p = ");
		System.out.print(alpha + "^" + b + " mod " + p + " = ");
		BigInteger kpubB = DHKE(b, alpha, p);
		System.out.println(kpubB);
		
		//Alice's session key computation
		System.out.print("Alice computes kpubB^a = ");
		System.out.print(kpubB + "^" + a + " mod " + p + " = ");
		BigInteger sessionKeyA = getSessionKey(kpubB, a, p);
		System.out.println(sessionKeyA);
		
		//Bob's session key computation
		System.out.print("Bob computes kpubA^b = ");
		System.out.print(kpubA + "^" + b + " mod " + p + " = ");
		BigInteger sessionKeyB = getSessionKey(kpubA, b, p);
		System.out.println(sessionKeyB);
		
		//Confirms session keys are the same
		if (sessionKeyA.equals(sessionKeyB)) {
			System.out.println(sessionKeyA + " = " + sessionKeyB);
			System.out.println("Session key computation successful!\n\n");
		} else {
			System.out.println(sessionKeyA + " != " + sessionKeyB);
			System.out.println("Session key computation failed.\n\n");
		}
	}
}
