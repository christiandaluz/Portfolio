import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.Base64.*;
public class RC4 {
    String cryptkey;
    byte[] s = new byte[256];
    byte[] t = new byte[256];
    Encoder encoder = Base64.getEncoder();
    Decoder decoder = Base64.getDecoder();

    /**
     * RC4 Constructor
     * @param key a String variable used for key scheduling
     */
    public RC4(String key) {
        //Set the key
        cryptkey = key;
    }

    /**
     * Creates a key schedule for use in encryption and decryption
     */
    public void keySchedule() {
        //Convert the key to a byte array
        byte[] key = cryptkey.getBytes();

        //Array s and t initializing
        for (int i = 0; i < 256; i++) {
            //Assign the numbers 1-256 to the s array
            s[i] = (byte) i;
            //The t array holds the numbers from the key array, 
            //	repeating every time the whole key is written
            t[i] = key[i % key.length];
        }

        //Initialize a variable j to 0 and a temp
        int j = 0;
        byte temp;

        //Key Scheduling
        for (int i = 0; i < 256; i++) {
            //j is equal to the sum of itself, s[i], t[i] mod 256
            j = (j + s[i] + t[i]) & 0xFF;

            //Swap s[i] and s[j]
            temp = s[i];
            s[i] = s[j];
            s[j] = temp;
        }
    }

    /**
     * Encrypts a byte array using the RC4 algorithm
     * @param plaintext a byte array containing unencrypted data
     * @return ciphertext a byte array containing the encrypted data
     */
    public byte[] encrypt(byte[] plaintext) {
        //Call the key scheduling algorithm
        keySchedule();

        //Initialize an array to hold the ciphertext
        byte[] ciphertext = new byte[plaintext.length];

        //Initialize variables for the Psuedo-Random Generation Algorithm
        int i = 0, j = 0, t = 0, k = 0;
        byte temp = 0;

        //Pseudo-Random Generation Algorithm and Encryption
        //Continue for the length of the plaintext
        for(int count = 0; count < plaintext.length; count++){
            //i is equal to the sum of itself and one mod 256
            i = (i + 1) & 0xFF;
            //j is equal to the sum of itself and s[i] mod 256
            j = (j + s[i]) & 0xFF;

            //Swap s[i] and s[j]
            temp = s[i];
            s[i] = s[j];
            s[j] = temp;

            //t is equal to the sum of s[i] and s[j] mod 256
            t = (s[i] + s[j]) & 0xFF;

            //k is equal to s at the index of t
            k = s[t];

            //The ciphertext at the index of count is equal to 
            //	the plaintext at the index of count XOR'd by k
            ciphertext[count] = (byte) (plaintext[count] ^ k);
        }

        //return the ciphertext byte array
        return ciphertext;
    }

    /**
     * Encrypts Base64 encoded data with the RC4 algorithm
     * @param plaintext a String of unencrypted data
     * @return ciphertext a String containing the encrypted data
     */
    public String encrypt64(String plaintext) {
        //Call the key scheduling algorithm
        keySchedule();

        //Decode the plaintext into a byte array
        byte[] pt = decoder.decode(plaintext);

        //Encrypt the data, encode it in Base64, and store it in an array
        byte[] ct = encoder.encode(encrypt(pt));

        //Convert the byte array to a String and return it
        String ciphertext = new String(ct);
        return ciphertext;
    }

    /**
     * Decrypts a byte array using the same algorithm used for encryption
     * @param ciphertext a byte array encrypted with RC4
     * @return plaintext, decrypted data
     */
    public byte[] decrypt(byte[] ciphertext) {
        //Call the key scheduling algorithm
        keySchedule();

        //The decryption algorithm is the same as that for encryption
        return encrypt(ciphertext);
    }

    /**
     * Decrypts Base64 encoded data with the RC4 algorithm
     * @param ciphertext a String encrypted with RC4 and Base64 encoded
     * @return plaintext a String containing the decrypted data
     */
    public String decrypt64(String ciphertext) {
        //Call the key scheduling algorithm
        keySchedule();

        //Decode the ciphertext and run the encrypt method
        byte[] pt = encrypt(decoder.decode(ciphertext));

        //Convert the byte array to a String and return it
        String plaintext = new String(pt);
        return plaintext;
    }

    public static void main(String[] args) throws UnsupportedEncodingException {
        String ciphertext = "CVs8AD9J7x5WUASv1EjSAO6rNdfr/fjhp+4ZTR3LbzJVlSn9sqdletpqFIyr3rOAmREjp1g=";
        String cryptkey = "cryptoclass";

        //Create an RC4 object and set it with the key
        RC4 rc4 = new RC4(cryptkey);

        //Decrypt the ciphertext into the plaintext 
        String plaintext = rc4.decrypt64(ciphertext);

        //Convert plaintext to bytes
        byte[] plaintextBytes = plaintext.getBytes();

        //Encode the plaintext
        byte[] encodedPlaintext = rc4.encoder.encode(plaintextBytes);
        String encoded = new String(encodedPlaintext);

        //Decrypt the plaintext
        String decrypted = rc4.encrypt64(encoded);

        //Print the results to the console
        System.out.println("The original ciphertext was: \t\t" + ciphertext +
            "\nThe decrypted ciphertext is: \t\t" + plaintext +
            "\nThe plaintext encrypted again gives us:\t" + decrypted);
    }
}