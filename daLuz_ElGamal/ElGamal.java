import java.math.BigInteger;
public class ElGamal {
	public static void main(String[] args) {
		//Declare and initialize variables
		BigInteger p = new BigInteger("467");
		BigInteger alpha = new BigInteger("2");
		BigInteger d, i, x;
		
		d = new BigInteger("105");
		i = new BigInteger("213");
		x = new BigInteger("33");
		
		//Compute results for first set of numbers
		computeResults(p, alpha, d, i, x);
		
		//compute the results for the next set of numbers
		d = BigInteger.valueOf(105);
		i = BigInteger.valueOf(123);
		x = BigInteger.valueOf(33);
		computeResults(p, alpha, d, i, x);
		
		//compute the results for the next set of numbers
		d = BigInteger.valueOf(300);
		i = BigInteger.valueOf(45);
		x = BigInteger.valueOf(248);
		computeResults(p, alpha, d, i, x);
		
		//compute the results for the next set of numbers
		d = BigInteger.valueOf(300);
		i = BigInteger.valueOf(47);
		x = BigInteger.valueOf(248);
		computeResults(p, alpha, d, i, x);
	}
	
	/*
	ke = kpubA = alpha^i mod p
	beta = alpha^d mod p
	decryption km = ke^d mod p
	encryption km = beta^i mod p
	y = x * km mod p
	x = y * km ^ -1 mod p
	*/
	
	//Calculates beta (alpha^d mod p)
	public static BigInteger computeBeta(BigInteger alpha, BigInteger d, BigInteger p) {
		return alpha.modPow(d, p);
	}
	
	//Calculate ke (alpha^i mod p)
	public static BigInteger computeke(BigInteger alpha, BigInteger i, BigInteger p) {
		return alpha.modPow(i, p);
	}
	
	//Calculates Alice's masking key (beta^i mod p)
	public static BigInteger computekmA(BigInteger beta, BigInteger i, BigInteger p) {
		return beta.modPow(i, p);
	}
	
	//Alice encrypts a message x (x*kmA mod p)
	public static BigInteger encrypt(BigInteger x, BigInteger kmA, BigInteger p) {
		return (x.multiply(kmA).mod(p));
	}
	
	//Calculates Bob's masking key (ke ^ d mod p)
	public static BigInteger computekmB(BigInteger ke, BigInteger d, BigInteger p) {
		return ke.modPow(d, p);
	}
	
	//Bob decrypts a message y (y*kmB^-1 mod p)
	public static BigInteger decrypt(BigInteger y, BigInteger kmB, BigInteger p) {
		return y.multiply(kmB.modInverse(p)).mod(p);
	}
	
	//Computes and prints results
	public static void computeResults(BigInteger p, BigInteger alpha, BigInteger d, BigInteger i, BigInteger x) {
		//Bob computes beta
		System.out.print("Bob computes beta = alpha^d mod p = " + alpha + "^" + d + " mod " + p + " = ");
		BigInteger beta = computeBeta(alpha, d, p);
		System.out.println(beta);
		
		//Alice computes ke
		System.out.print("Alice computes ke = alpha^i mod p = " + alpha + "^" + i + " mod " + p + " = ");
		BigInteger ke = computeke(alpha, i, p);
		System.out.println(ke);
		
		//Alice computes her masking key
		System.out.print("Alice computes her km = beta^i mod p = " + beta + "^" + i + " mod " + p + " = ");
		BigInteger kmA = computekmA(beta, i, p);
		System.out.println(kmA);
		
		//Alice encrypts x
		System.out.print("Alice encrypts x; y = x*kmA mod p = " + x + "*" + kmA + " mod " + p + " = ");
		BigInteger y = encrypt(x, kmA, p);
		System.out.println(y);
		
		//Bob computes his masking key
		System.out.print("Bob computers his km = ke^d mod p = " + ke  + "^" + d + " mod " + p + " = ");
		BigInteger kmB = computekmB(ke, d, p);
		System.out.println(kmB);
		
		//Bob decrypts y
		System.out.print("Bob decrypts y: x = y*kmB^-1 mod p = " + y + "*" + kmB + "^-1" + " mod " + p + " = ");
		BigInteger decryptedY = decrypt(y, kmB, p);
		System.out.println(decryptedY);
		
		if (x.equals(decryptedY)) {
			System.out.println(x + " = " + decryptedY);
			System.out.println("Decryption successful!\n\n");
		} else {
			System.out.println(x + " != " + decryptedY);
			System.out.println("Decryption failed.\n\n");
		}
	}
}
